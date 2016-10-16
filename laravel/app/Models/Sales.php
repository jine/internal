<?php
namespace App\Models;
use DB;

class Sales extends Entity
{
	protected $type = "accounting_transaction";
	protected $join = "accounting_transaction";
	protected $columns = [
		"entity_id" => [
			"column" => "entity.entity_id",
			"select" => "entity.entity_id",
		],
		"created_at" => [
			"column" => "entity.created_at",
			"select" => "DATE_FORMAT(entity.created_at, '%Y-%m-%dT%H:%i:%sZ')",
		],
		"updated_at" => [
			"column" => "entity.updated_at",
			"select" => "DATE_FORMAT(entity.updated_at, '%Y-%m-%dT%H:%i:%sZ')",
		],
		"transaction_title" => [
			"column" => "entity.title",
			"select" => "entity.title",
		],
		"transaction_description" => [
			"column" => "entity.description",
			"select" => "entity.description",
		],
		"accounting_instruction" => [
			"column" => "accounting_transaction.accounting_instruction",
			"select" => "accounting_transaction.accounting_instruction",
		],
		"accounting_account" => [
			"column" => "accounting_transaction.accounting_account",
			"select" => "accounting_transaction.accounting_account",
		],
		".accounting_cost_center" => [
			"column" => "accounting_transaction.accounting_cost_center",
			"select" => "accounting_transaction.accounting_cost_center",
		],
		"amount" => [
			"column" => "accounting_transaction.amount",
			"select" => "accounting_transaction.amount",
		],
		"external_id" => [
			"column" => "accounting_transaction.external_id",
			"select" => "accounting_transaction.external_id",
		],
		"instruction_title" => [
			"column" => "ie.title",
			"select" => "ie.title",
		],
		"instruction_number" => [
			"column" => "accounting_instruction.instruction_number",
			"select" => "accounting_instruction.instruction_number",
		],
		"accounting_date" => [
			"column" => "accounting_instruction.accounting_date",
			"select" => "accounting_instruction.accounting_date",
		],
		"extid" => [
			"column" => "accounting_instruction.external_id",
			"select" => "accounting_instruction.external_id",
		],
		// Joined product
		"product_id" => [
			"column" => "pe.entity_id",
			"select" => "pe.entity_id",
		],
		"product_title" => [
			"column" => "pe.title",
			"select" => "pe.title",
		],
		// Joined member
		"member_number" => [
			"column" => "member.member_number",
			"select" => "member.member_number",
		],
		"member_firstname" => [
			"column" => "member.firstname",
			"select" => "member.firstname",
		],
		"member_lastname" => [
			"column" => "member.lastname",
			"select" => "member.lastname",
		],
	];
	protected $sort = ["accounting_date", "desc"];

	/**
	 *
	 */
	public function _list($filters = [])
	{

		// Preprocessing (join or type and sorting)
		$this->_preprocessFilters($filters);

		// Build base query
		$query = $this->_buildLoadQuery($filters);

/*
		// Go through filters
		foreach($filters as $filter)
		{
			// Filter on accounting period
			if("accountingperiod" == $filter[0])
			{
				$query = $query
					->leftJoin("accounting_period", "accounting_period.entity_id", "=", "accounting_instruction.accounting_period")
					->where("accounting_period.name", $filter[1], $filter[2]);
			}
			// Filter on accounting period
			if("account_number" == $filter[0])
			{
				$query = $query
					->leftJoin("accounting_account", "accounting_account.entity_id", "=", "accounting_transaction.accounting_account")
					->where("accounting_account.account_number", $filter[1], $filter[2]);
			}
		}
*/

		$query = $this->_applyFilter($query, $filters);

		// Load the instruction
		$query = $query
			->join("accounting_instruction", "accounting_instruction.entity_id", "=", "accounting_transaction.accounting_instruction")
			->join("entity AS ie", "ie.entity_id", "=", "accounting_instruction.entity_id");

		// Join product
		$query = $query
			->join("relation AS r1", "r1.entity1", "=", "entity.entity_id")
//			->join("accounting_instruction", "accounting_instruction.entity_id", "=", "accounting_transaction.accounting_instruction")
			->join("entity AS pe", "pe.entity_id", "=", "r1.entity2")
			->where("pe.type", "=", "product");

		// Join member
		$query = $query
			->leftJoin("member", "member.entity_id", "=", DB::Raw("(SELECT relation.entity2 FROM relation LEFT JOIN entity e ON e.entity_id = relation.entity2 WHERE e.type=\"member\" AND relation.entity1 = entity.entity_id LIMIT 1)"));

/*
		LEFT JOIN entity em
		ON em.entity_id = r2.entity2
		AND em.type = "member"
		JOIN relation r2
		ON r2.entity1 = entity.entity_id
		WHERE r2.entity2 = entity.entity_id
*/
/*
		$query = $query
			->join("relation AS r2", function($join) {
				$join->on("r2.entity1", "=", "entity.entity_id");
			})
			->leftJoin("entity AS em", function($join) {
				$join->on("em.entity_id", "=", "r2.entity2")
					->where("em.type", "=", "member");
			})
			->leftJoin("member", "member.entity_id", "=", "em.entity_id");
*/
		// Sort
		$query = $this->_applySorting($query);

		// Paginate
		if($this->pagination != null)
		{
			//			$meep = $this->columns;
			$meep = ['entity.entity_id AS entity_id'];
			$query->paginate($this->pagination, $meep);
		}

		// Debug
//		print_r($query->toSql());
//		die();

		// Run the MySQL query
		$result = $query->get();
		$data = [];
		foreach($result as $row)
		{
//			$row->product_id = "meep 2";
			$data[] = $row;
		}

		$result = [
			"data" => $data
		];

		if($this->pagination != null)
		{
			$result["total"]    = $query->count();
			$result["per_page"] = $this->pagination;
			$result["last_page"] = ceil($result["total"] / $result["per_page"]);
		}

		return $result;
	}
}