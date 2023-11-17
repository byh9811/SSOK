import './App.css';
import { useState } from 'react';
import { Header } from './Component/Header';
import ItemList from './Component/ItemList';
import Payment from './Component/Payment';
import SelectList from './Component/SelectList';
import axios from 'axios';
import { useEffect } from 'react';

function App() {
  
  const [totalMoney, setTotalMoney] = useState(0);
  const [sellItem, setSellItem] = useState([]);
  const [selectItem, setSeletItem] = useState([]);

  useEffect(() => {
    // async function a(){
    //   await axios.post('https://member.ssok.site/api/member-service/serivce', {
    //     firstName: 'Fred',
    //     lastName: 'Flintstone'
    //   }).then((response)=>{
    //     return response;
    //   });
    // }
    async function b(){
      await axios.get('https://k9c107.p.ssafy.io/pos/item-service/item/list', {
      }).then((response)=>{
        console.log(response.data.itemList)
        setSellItem(response.data.itemList);
        // return response.data;
      });
    }
    
    return (
      b
    )
  }, [])

  function addItem(newItem){
    for(var i =0; i<selectItem.length;i++){
      if(selectItem[i].itemName==newItem.itemName){
        selectItem[i].itemCnt++;
        selectItem[i].itemTotalPrice += newItem.itemPrice;
        setSeletItem([...selectItem]);
        setTotalMoney(Number(totalMoney) + Number(newItem.itemPrice))
        return;
      }
    }
    setSeletItem([...selectItem, newItem])
    setTotalMoney(Number(totalMoney) + Number(newItem.itemPrice))
  }

  function removeItem(rmItem){
    for(var i =0; i<selectItem.length; i++){
      if(selectItem[i].itemName==rmItem.itemName){
        selectItem[i].itemCnt--;
        selectItem[i].itemTotalPrice -= rmItem.itemPrice;
        
        const newSelectItem = selectItem.filter((it)=> it.itemCnt!=0);
        setSeletItem(newSelectItem);
        setTotalMoney(Number(totalMoney) - Number(rmItem.itemPrice))
        return;
      }
    }
  }

  function removeAll(){
    setSeletItem([]);
    setTotalMoney(0)
  }

  return (
    <div className="App">
      <div className='totalWrapper'>
        <Header></Header>
        <div className='contentWrapper'>
          <div className='leftContentWrapper'>
            <ItemList sellItem={sellItem} addItem={addItem}></ItemList>
            <Payment totalMoney={totalMoney} selectItem={selectItem} removeAll={removeAll}></Payment>
          </div>
          
          <div className='rightContentWrapper'>
            <SelectList selectItem={selectItem} removeItem={removeItem} removeAll={removeAll}></SelectList>
          </div>

        </div>
      </div>
    </div>
  );
}

export default App;
