import Backbone from 'backbone'
import InvoiceModel from '../Models/Account'

var InvoiceCollection = Backbone.PageableCollection.extend(
{
	model: InvoiceModel,
	url: "/economy/2015/invoice",
});

module.exports = InvoiceCollection;