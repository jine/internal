var Router = ReactRouter;
var DefaultRoute = Router.DefaultRoute;
var Link = Router.Link;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var keyHeaders = new Backbone.Model({
  title: "Lab Access",
  headers: ["#", "Name", "Expiry Date"],
  blurb: "Wherein the keys are edited and henceforth accessed.",
  caption: "Change keys"
});

var keys = new Backbone.Collection([
  {key: 0, name: 'Jan Jansson', expires: new Date()},
  {key: 1, name: 'Michel Michellin', expires: new Date()}
]);

var App = React.createClass({
    mixins: [Backbone.React.Component.mixin],
  render: function () {
    return (
      <div>
        <Nav/>
        <SideNav/>
        <div className="uk-container uk-container-center uk-margin-top">
          <div className="uk-grid">
            <RouteHandler model={keyHeaders} collection={keys}/>
          </div>
        </div>
      </div>
    );
  }
});


var Nav = React.createClass({
  render: function () {
    return (
      <nav className="uk-navbar">
        <div className="uk-container uk-container-center">
          <Link to="app" className="uk-navbar-brand">Makerspace Internal</Link>
          <ul className="uk-navbar-nav uk-hidden-small uk-navbar-attached">
            <li><Link to="members">Members</Link></li>
            <li><Link to="keys">Lab Access</Link></li>
          </ul>
          <div className="uk-navbar-flip">
            <a className="uk-navbar-toggle uk-visible-small" data-uk-offcanvas="{target:'#sidenav'}"></a>
          </div>
        </div>
      </nav>
    );
  }
});

var SideNav = React.createClass({
  render: function () {
    return (
      <div id="sidenav" className="uk-offcanvas">
        <div className="uk-offcanvas-bar">
          <ul className="uk-nav uk-nav-offcanvas" data-uk-nav>
            <li><Link to="app">Makerspace Internal</Link></li>
            <li><Link to="members">Members</Link></li>
            <li><Link to="keys">Lab Access</Link></li>
          </ul>
        </div>
      </div>
    );
  }
});

var Members = React.createClass({
  render: function () {
    return (
      <div className="uk-width-1-1">
        <h1>Member editor</h1>
        <p>Remove the members you dislike.</p>
      </div>
    );
  }
});

var Dashboard = React.createClass({
  render: function () {
    return (
      <div className="uk-width-1-1">
        <div className="uk-panel uk-panel-box uk-panel-box-primary">
        	<h1 className="uk-heading-large">Makerspace internal systems thingamajig</h1>
        </div>
      </div>
    );
  }
});

var routes = (
  <Route name="app" path="/" handler={App}>
    <Route name="members" handler={Members}/>
    <Route name="keys" handler={Keys}/>
    <DefaultRoute handler={Dashboard}/>
  </Route>
);

Router.run(routes, Router.HashLocation, function (Handler) {
  React.render(<Handler />, document.body);
});