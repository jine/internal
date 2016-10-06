import React from 'react'
import { browserHistory } from 'react-router'
import { Select, Async } from 'react-select';
import config from '../config'

/**
 * TODO:
 *   Validate data before sending
 */

class MailSendHandler extends React.Component
{
	constructor(props)
	{
		super(props);
		this.state = {
			type: "email",
			recipients: [],
			subject: "",
			body: "",
		};
	}

	// Change the between E-mail and SMS
	changeType()
	{
		this.setState({
			type: this.refs.type.value
		});

		if(this.refs.type.value == "sms")
		{
			$("#subject_container").hide();
		}
		else
		{
			$("#subject_container").show();
		}
	}

	changeRecipient(value)
	{
		this.setState({
			recipients: value
		});

		// Clear the search history so there is no drop down with old data after adding a recipient
		this.refs.recps.setState({options: []});
	}

	changeSubject()
	{
		this.setState({
			subject: this.refs.subject.value
		});
	}

	changeBody()
	{
		this.setState({
			body: this.refs.body.value
		});

		// Update the character counter
		$("#characterCounter").html(this.refs.body.value.length);
	}

	// Disable client side filtering
	filter(option, filterString)
	{
		return option;
	}

	search(input, callback)
	{
		// Clear the search history so there is no drop down with old data when search text input is empty
		if(!input)
		{
			return Promise.resolve({ options: [] });
		}

		$.ajax({
			method: "POST",
			url: config.apiBasePath + "/member/search",
			data: JSON.stringify({
				q: input,
			}),
		}).done(function(data) {
			setTimeout(function() {
				callback(null, {
					options: data,
					// CAREFUL! Only set this to true when there are no more options,
					// or more specific queries will not be sent to the server.
//					complete: true
				});
			}, 100);

		});
	}

	gotoMember(value, event)
	{
		UIkit.modal.alert("TODO: Go to member " + value.label);
	}

	// Send an API request and queue the message to be sent
	send(event)
	{
		// Prevent the form from being submitted
		event.preventDefault();

		var type       = this.state.type;
		var recipients = this.state.recipients;
		var subject    = this.state.subject;
		var body       = this.state.body;

		// Send API request
		$.ajax({
			method: "POST",
			url: config.apiBasePath + "/mail",
			data: JSON.stringify({
				type,
				recipients,
				subject,
				body
			}),
		}).done(function (){
			// TODO: Falhantering
			browserHistory.push("/mail/history");
		});
	}

	render()
	{
		return (
			<div>
				<h2>Skapa utskick</h2>

				<form className="uk-form uk-form-horizontal" onSubmit={this.send.bind(this)}>
					<div className="uk-form-row">
						<label className="uk-form-label" htmlFor="type">
							Typ
						</label>
						<div className="uk-form-controls">
							<select id="type" ref="type" className="uk-form-width-medium" onChange={this.changeType.bind(this)}>
								<option value="email">E-post</option>
								<option value="sms">SMS</option>
							</select>
						</div>
					</div>

					<div className="uk-form-row">
						<label className="uk-form-label" htmlFor="recipient">
							Mottagare
						</label>
						<div className="uk-form-controls">
							<Async ref="recps" multi cache={false} name="recipients" filterOption={this.filter} loadOptions={this.search} value={this.state.recipients} onChange={this.changeRecipient.bind(this)} onValueClick={this.gotoMember} />
						</div>
					</div>

					<div className="uk-form-row" id="subject_container">
						<label className="uk-form-label" htmlFor="subject">
							Ärende
						</label>
						<div className="uk-form-controls">
							<div className="uk-form-icon">
    							<i className="uk-icon-commenting"></i>
								<input ref="subject" type="text" id="subject" name="subject" className="uk-form-width-large" onChange={this.changeSubject.bind(this)} />
							</div>
						</div>
					</div>

					<div className="uk-form-row">
						<label className="uk-form-label" htmlFor="body">
							Meddelande
						</label>

						<div className="uk-form-controls">
							<textarea id="body" ref="body" className="uk-form-width-large" rows="8" onChange={this.changeBody.bind(this)}></textarea>
						</div>
					</div>

					<div className="uk-form-row">
						<div className="uk-form-controls">
							<p className="uk-float-left"><span id="characterCounter">0</span> tecken</p>
							<button type="submit" className="uk-float-right uk-button uk-button-success">Skicka</button>
						</div>
					</div>
				</form>
			</div>
		);
	}
}
MailSendHandler.title = "Skapa utskick";

module.exports = { MailSendHandler }