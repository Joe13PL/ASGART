local function onPlayerUseItemHandler(instance, amount, hand)
{
  local packet = Packet();
  packet.writeInt8(packets.useItem);
  packet.writeInt16(Items.id(instance));
  packet.send(RELIABLE);
}
addEventHandler("onUseItem", onPlayerUseItemHandler);
