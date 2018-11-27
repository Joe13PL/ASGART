local _giveItem = giveItem;
local _removeItem = removeItem;

//FUNC
function myGiveItem(pid, _instance, _amount)
{
  local eq = getPlayerEq(pid);
  local packet = Packet();
  packet.writeInt8(packets.giveItem);
  packet.writeInt16(Items.id(_instance));
  packet.writeInt8(_amount);
  packet.send(pid, RELIABLE_ORDERED);

  if(eq.len() < 1)
  {
    eq.push({instance = _instance, amount = _amount,});
  }
  else
  {
    foreach(v, k in eq)
    {
      if(k.instance == _instance)
      {
        eq[v].amount = eq[v].amount + _amount;
        return;
      }
    }
    eq.push({instance = _instance, amount = _amount,});
  }
}

local function myRemoveItem(pid, _instance, _amount)
{
  local eq = getPlayerEq(pid);
  local packet = Packet();
  if(eq.len() >= 1)
  {
    foreach(v, k in eq)
    {
      if(eq[v].instance == _instance)
      {
        if(eq[v].amount <= _amount)
        {
          eq.remove(v);
        }
        else
        {
          eq[v].amount = eq[v].amount - _amount;
        }
        packet.writeInt8(packets.removeItem);
        packet.writeInt16(Items.id(_instance));
        packet.writeInt8(_amount);
        packet.send(pid, RELIABLE_ORDERED);
        return;
      }
      else
      {
        print("Blad w funkcji myRemoveItem. Instance: "+_instance+" Nie istnieje u gracza: "+pid);
        //return;
      }
    }
  }
  else
  {
    print("Blad w funkcji myRemoveItem. Tabelka eq gracza: "+pid+" jest pusta.");
    //return;
  }
}

//HOOKS:
function giveItem(pid, instance, amount)
{
  myGiveItem(pid, instance, amount);
  _giveItem(pid, Items.id(instance), amount);
}

function removeItem(pid, instance, amount)
{
  myRemoveItem(pid, instance, amount);
  _removeItem(pid, Items.id(instance), amount);
}


//CALLBACKS
local function dropItemHandler(pid, item)
{
  myRemoveItem(pid, item.instance, item.amount);
sendMessageToPlayer(0, 255, 0, 0, "SERVER: REMOVE: "+item.instance+" "+item.amount+"LEN: "+getPlayerEq(0).len());
  //cancelEvent();
}

local function takeItemHandler(pid, item)
{
  myGiveItem(pid, item.instance, item.amount);
  sendMessageToPlayer(0, 255, 0, 0, "SERVER: GIVE: "+item.instance+" "+item.amount+"LEN: "+getPlayerEq(0).len());
}

local function useItemHandler(pid, instance)
{
  myRemoveItem(pid, instance, 1);
}

addEventHandler("onPlayerDropItem", dropItemHandler);
addEventHandler("onPlayerTakeItem", takeItemHandler);
addEventHandler("onPlayerUseItem", useItemHandler);

addEventHandler("onPlayerJoin", function(pid)
{
  giveItem(pid, "ITPO_SPEED", 3);
  giveItem(pid, "ITAR_XARDAS", 1);
  giveItem(pid, "ITFO_BEER", 2);
});

//giveItem(0, "ITPO_SPEED", 3);
//giveItem(0, "ITAR_XARDAS", 1);
//giveItem(0, "ITPO_SPEED", 3);
//removeItem(0, "ITPO_SPEED", 3);
//giveItem(0, "ITPO_SPEED", 3);


foreach(v, k in getPlayerEq(0))
{
  print(k.instance+" "+k.amount);
}
