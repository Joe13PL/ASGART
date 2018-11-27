local _print = print;
function print(text)
{
  Chat.print(0, 255, 0, " "+text);
  _print(text);
}
