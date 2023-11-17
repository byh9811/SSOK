import React from 'react'
import Item from './Item'
import { useState, useEffect } from 'react'

const ItemList = ({sellItem, addItem}) => {

  const [items, setItems] = useState(sellItem)

  useEffect(() => {
    setItems(sellItem)
  }, [sellItem])
  

  return (
    <div className='itemListWrapper'>
      {items.map((a,i)=>{
        return <Item item={a} key={i} addItem={addItem}></Item>
      })}
    </div>
  )
}

export default ItemList