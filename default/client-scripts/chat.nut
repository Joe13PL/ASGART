/////////////////////////////////////////
///	Defines
/////////////////////////////////////////

const CHAT_LINE_SIZE = 15;
const CHAT_VISIBLE = true;

/////////////////////////////////////////
///	Line types
/////////////////////////////////////////

class ChatLine
{
	constructor(r, g, b, text)
	{
		_line = Draw(0, 0, text);
		_line.setColor(r, g, b);
	}

	function show()
	{
		_line.visible = true;
	}

	function hide()
	{
		_line.visible = false;
	}

	function update(x, y)
	{
		_line.setPositionPx(x, y);
	}

	function offset()
	{
		return _line.heightPx;
	}

	_line = null;
}

//---------------------------------------

class ChatPlayerLine extends ChatLine
{
	constructor(pid, r, g, b, text)
	{
		base.constructor(r, g, b, text);
		
		local color = getPlayerColor(pid);
		_nickname = Draw(0, 0, getPlayerName(pid) + ": ");
		_nickname.setColor(color.r, color.g, color.b);
	}

	function show()
	{
		base.show();
		_nickname.visible = true;
	}

	function hide()
	{
		base.hide();
		_nickname.visible = false;
	}

	function update(x, y)
	{
		base.update(_nickname.widthPx + x, y);
		_nickname.setPositionPx(x, y);
	}

	function offset()
	{
		return _nickname.heightPx;
	}

	_nickname = null;
}

/////////////////////////////////////////
///	Chat
/////////////////////////////////////////

Chat <- {
	x = 5,
	y = 5,
	visible = CHAT_VISIBLE,
	
	_lines = queue(),
	_maxLines = CHAT_LINE_SIZE,
}

//---------------------------------------

function Chat::toggle()
{
	visible ? hide() : show();
}

//---------------------------------------

function Chat::show()
{
	visible = true;

	foreach (line in _lines)
		line.show();
}

//---------------------------------------

function Chat::hide()
{
	visible = false;

	foreach (line in _lines)
		line.hide();
}

//---------------------------------------

function Chat::printPlayer(pid, r, g, b, msg)
{
	_printLine(ChatPlayerLine(pid, r, g, b, msg));
}

//---------------------------------------

function Chat::print(r, g, b, msg)
{
	_printLine(ChatLine(r, g, b, msg));
}

//---------------------------------------

function Chat::_printLine(line)
{
	if (visible) line.show();
	_lines.push(line);

	if (_lines.len() > _maxLines)
	{
		local line = _lines.front();
		line.hide();

		_lines.pop();
	}
	
	_calcPosition();
}

//---------------------------------------

function Chat::_calcPosition()
{
	local offset = 0;
	foreach (line in _lines)
	{
		line.update(x, y + offset);
		offset += line.offset();
	}

	chatInputSetPosition(x, any(y + offset));
}

/////////////////////////////////////////
///	Events
/////////////////////////////////////////

local function keyHandler(key)
{
	if (chatInputIsOpen())
	{
		playGesticulation(heroId);

		switch (key)
		{
		case KEY_RETURN:
			chatInputSend();
			disableControls(true);
			break;

		case KEY_ESCAPE:
			chatInputClose();
			disableControls(true);
			break;
		}
	}
	else
	{
		switch (key)
		{
		case KEY_T:
			if (Chat.visible)
			{
				chatInputOpen();
				disableControls(false);
			}
			break;

		case KEY_F7:
			Chat.toggle();
			break;
		}
	}
}

addEventHandler("onKey", keyHandler);

//---------------------------------------

local function messageHandler(pid, r, g, b, message)
{
	if (pid != -1)
		Chat.printPlayer(pid, r, g, b, message);
	else
		Chat.print(r, g, b, message);
}

addEventHandler("onPlayerMessage", messageHandler);

// Loaded
print("chat.nut loaded...")