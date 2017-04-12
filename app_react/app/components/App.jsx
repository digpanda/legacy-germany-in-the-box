import React from 'react';
import CounterComponent from 'components/Counter';

export default class App extends React.Component {
  render() {
    return (
      <div>
        <div className="+spacer"></div>
        <CounterComponent count={0} />
      </div>
    );
  }
}
