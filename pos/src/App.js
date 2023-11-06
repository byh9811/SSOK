import './App.css';
import { Header } from './Component/Header';
import ItemList from './Component/ItemList';
import Payment from './Component/Payment';
import SelectList from './Component/SelectList';

function App() {
  
  return (
    <div className="App">
      <div className='totalWrapper'>
        <Header></Header>

        <div className='contentWrapper'>
          
          <div className='leftContentWrapper'>
            <ItemList></ItemList>
            <Payment></Payment>
          </div>
          
          <div className='rightContentWrapper'>
            <SelectList></SelectList>
          </div>

        </div>
      </div>
    </div>
  );
}

export default App;
