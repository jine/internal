import React from 'react'
import BackboneReact from 'backbone-react-component'
import {
	BackboneTable,
} from '../BackboneTable'
import { Link } from 'react-router'
import { Currency, DateField } from '../Common'

var Transactions = React.createClass({
	mixins: [Backbone.React.Component.mixin, BackboneTable],

	getInitialState: function()
	{
		return {
			columns: 6,
		};
	},

	componentWillMount: function()
	{
		if(this.props.member_number !== undefined)
		{
			// Load RFID keys related to member
			this.state.collection.fetch({
				data: {
					relation: {
						type: "member",
						member_number: this.props.member_number,
					}
				}
			});
		}
		else
		{
			// Load all RFID keys
			this.state.collection.fetch();
		}
	},

	renderHeader: function()
	{
		return (
			<tr>
				<th>Bokföringsdatum</th>
				<th>Verifikation</th>
				<th>Transaktion</th>
				<th className="uk-text-right">Belopp</th>
				<th className="uk-text-right">Saldo</th>
				<th></th>
			</tr>
		);
	},

	renderRow: function (row, i)
	{
		if(typeof row.files != "undefined")
		{
			var icon = <i className="uk-icon-file"></i>;
		}
		else
		{
			var icon = "";
		}

		return (
			<tr key={i}>
				<td><DateField date={row.accounting_date}/></td>
				<td><Link to={"/economy/instruction/" + row.instruction_number}>{row.instruction_number} {row.instruction_title}</Link></td>
				<td>{row.transaction_title}</td>
				<td className="uk-text-right"><Currency value={row.amount} currency="SEK" /></td>
				<td className="uk-text-right"><Currency value={row.balance} currency="SEK" /></td>
				<td>{icon}</td>
			</tr>
		);
	},
});

module.exports = {
	Transactions,
}