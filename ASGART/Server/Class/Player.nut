//Server
playerList <- [];
local player =
{
  eq = [],

}

for(local p = 0; p<getMaxSlots(); p++)
{
  playerList.push(player);
}

function getPlayerEq(pid)
{
  //if(!isPlayerSpawned(pid)) return;
  return playerList[pid].eq;
}
