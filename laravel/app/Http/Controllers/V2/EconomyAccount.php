<?php
namespace App\Http\Controllers\V2;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

use App\Models\AccountingAccount;

use App\Traits\AccountingPeriod;
use App\Traits\Pagination;

class EconomyAccount extends Controller
{
	use AccountingPeriod, Pagination;

	/**
	 * Returns the masterledger
	 *
	 * The masterledger is basically a list of accounts, but we only show accounts with a balance != 0
	 */
	function masterledger(Request $request, $accountingperiod)
	{
		// Check that the specified accounting period exists
		$x = $this->_accountingPeriodOrFail($accountingperiod);
		if(null !== $x)
		{
			return $x;
		}

		// Return all account that have a balance not equal to 0
		return AccountingAccount::list(
			[
				"transactions"     => [">", 0],
				"accountingperiod" => ["=", $accountingperiod],
			]
		);
	}

	/**
	 * Returns a list of accounts
	 */
	function list(Request $request, $accountingperiod)
	{
		// Check that the specified accounting period exists
		$x = $this->_accountingPeriodOrFail($accountingperiod);
		if(null !== $x)
		{
			return $x;
		}

		// Paging filter
		$filters = [
			"per_page" => $this->per_page($request), // TODO: Rename?
		];

		// Filter on relations
		if(!empty($request->get("relations")))
		{
			$filters["relations"] = $request->get("relations");
		}

		// Filter on search
		if(!empty($request->get("search")))
		{
			$filters["search"] = $request->get("search");
		}

		// Sorting
		if(!empty($request->get("sort_by")))
		{
			$order = ($request->get("sort_order") == "desc" ? "desc" : "asc");
			$filters["sort"] = [$request->get("sort_by"), $order];
		}

		// Load data from database
		$result = call_user_func("\App\Models\AccountingAccount::list", $filters);

		// Return json array
		return $result;
	}

	/**
	 * Create account
	 */
	function create(Request $request, $accountingperiod)
	{
		$json = $request->json()->all();

		// Get id of accounting period
		$accountingperiod_id = $this->_getAccountingPeriodId($accountingperiod);
		if(null === $accountingperiod_id)
		{
			return Response()->json([
				"message" => "Could not find the specified accounting period",
			], 404);
		}

		// We need to check that the provided account number is not in conflict with an existing one
		if($this->_accountNumberIsExisting($accountingperiod, $json["account_number"]))
		{
			return Response()->json([
				"status"  => "error",
				"message" => "The specified account number does already exist",
			], 409);
		}

		// Create new entity
		$entity = new AccountingAccount;
		$entity->account_number     = $json["account_number"];
		$entity->title              = $json["title"];
		$entity->description        = $json["description"] ?? null;
		$entity->accounting_period  = $accountingperiod_id;

		// Validate input
		$entity->validate();

		// Save the entity
		$entity->save();

		// Send response to client
		return Response()->json([
			"status" => "created",
			"entity" => $entity->toArray(),
		], 201);
	}

	/**
	 * Returns an single account
	 */
	function read(Request $request, $accountingperiod, $account_number)
	{
		// Get id of accounting period
		$accountingperiod_id = $this->_getAccountingPeriodId($accountingperiod);
		if(null === $accountingperiod_id)
		{
			return Response()->json([
				"message" => "Could not find the specified accounting period",
			], 404);
		}

		// Load the account
		$account = AccountingAccount::load([
			["accountingperiod", "=", $accountingperiod],
			["account_number",   "=", $account_number],
		]);

		// Generate an error if there is no such account
		if(false === $account)
		{
			return Response()->json([
				"message" => "No account with specified account number in the selected accounting period",
			], 404);
		}
		else
		{
			return $account;
		}
	}

	/**
	 *
	 */
	function update(Request $request, $accountingperiod, $id)
	{
		return ['error' => 'not implemented'];
	}

	/**
	 *
	 */
	function delete(Request $request, $accountingperiod, $account_number)
	{
		$entity = $this->read($request, $accountingperiod, $account_number);

		if($entity->delete())
		{
			return [
				"status" => "deleted"
			];
		}
		else
		{
			return [
				"status" => "error"
			];
		}
	}

	/**
	 * TODO: Kolla om kontot finns redan
	 */
	function _accountNumberIsExisting($account_number)
	{
		return false;
	}
}
