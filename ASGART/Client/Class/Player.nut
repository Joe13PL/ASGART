local player =
{
  eq = [],
}

function getPlayerEq()
{
  if(player.eq.len() >= 1)
  return player.eq;

  return null;
}

local function removeItem(instance, amount)
{
  local eq = player.eq;

  if(eq.len() >=1)
  {
    foreach(v, k in eq)
    {
      if(k.instance != instance)
      {
        print("Blad w funkcji removeItem. Instance: "+instance+" Nie istnieje.");
      }
      else
      {
        //return;
        if(k.amount <= amount)
        {
          eq.remove(v);
        }
        else
        {
          eq[v].amount = eq[v].amount - amount;
        }
        return;
      }
    }
  }
  else
  {
    print("Blad w funkcji removeItem. Tabelka eq jest pusta.");
    //return;
  }
}

local function giveItem(instance, amount)
{
  local eq = player.eq;

  if(eq.len() < 1)
  {
    eq.push({instance = instance, amount = amount,});
  }
  else
  {
    foreach(v, k in eq)
    {
      if(k.instance == instance)
      {
        eq[v].amount = eq[v].amount + amount;
        return;
      }
    }
    eq.push({instance = instance, amount = amount,});
  }
}

local function eq(type)
{
  if(type == "give")
  {
    foreach(item in getPlayerEq())
    {
      print("GIVE: "+item.instance+" "+item.amount+"LEN: "+ getPlayerEq().len());
    }
  }
  else if(type == "remove")
  {
    foreach(item in getPlayerEq())
    {
      print("REMOVE: "+item.instance+" "+item.amount+"LEN: "+ getPlayerEq().len());
    }
  }
}


local function receivePackets(packet)
{
  local pkt = packet.readInt8();

  if(pkt == packets.giveItem)
  {
    local i16 = packet.readInt16();
    local i8 = packet.readInt8();
    giveItem(Items.name(i16), i8);
    print("CLIENT: GIVE: " + Items.name(i16)+ " "+ i8+" LEN: "+player.eq.len());
    //eq("give");
  }
  if(pkt == packets.removeItem)
  {
    local i16 = packet.readInt16();
    local i8 = packet.readInt8();
    removeItem(Items.name(i16), i8)
    print("SERVER: REMOVE: " + Items.name(i16)+ " "+ i8+" LEN: "+player.eq.len());
    //eq("remove");
  }
}
addEventHandler("onPacket", receivePackets);
