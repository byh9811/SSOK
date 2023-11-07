import React from 'react'
import SelectItem from './SelectItem'
import { useState,useEffect } from 'react'

const SelectList = ({selectItem, removeItem, removeAll}) => {

  const [first, setfirst] = useState(selectItem)
  
  useEffect(() => {
    setfirst(selectItem);
  }, [selectItem])

  function delAll(){
    removeAll();
  }

  return (
    <div className='selectListWrapper'>
      <div className="itemInfo">
        <div className='selectItemName'>상품명</div>
        <div className='selectItemCnt'>수량</div>
        <div className='selectItemPrice'>가격</div>
        <div className='rmBtn'><button onClick={delAll}>모두 취소</button></div>
      </div>
      {first.map((a,i)=>{
        return <SelectItem item={a} key={i} removeItem={removeItem}></SelectItem>
      })}
    </div>
  )
}

export default SelectList