addEvent("onPlayerUseItem");


local function onPlayerUseItem(pid, packet)
{
  local pkt = packet.readInt8();
  if(pkt == packets.useItem)
  {
    callEvent("onPlayerUseItem", pid, Items.name(packet.readInt16()));
  }
}
addEventHandler("onPacket", onPlayerUseItem);
