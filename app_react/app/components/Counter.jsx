import React from 'react';

export default class CounterComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      count: props.count
    };
  }
  decrementClick() {
    if (this.state.count > 0) {
      var newCount = this.state.count - 1;
      this.setState({ count : newCount })
    }
  }
  incrementClick() {
    var newCount = this.state.count + 1;
    this.setState({ count : newCount })
  }
  render() {
    return (
      <div>
        <a href="#" onClick={this.decrementClick.bind(this)} className="+red">Decrement</a> | 
        <a href="#" onClick={this.incrementClick.bind(this)} className="+blue">Increment</a>
        <div>Current counter : {this.state.count}</div>
      </div>
    )
  }
}
