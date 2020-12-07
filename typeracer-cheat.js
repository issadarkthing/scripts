function epicWin(time = 115) {
	let counter = -1;
	const inputPanel = document.getElementsByClassName("inputPanel")[0].querySelectorAll("span")
	const firstWord = inputPanel[0].innerHTML + inputPanel[1].innerHTML
	const restOfText = inputPanel[2].innerHTML;
	const fullText = firstWord.concat(restOfText);
	const inputBox = document.getElementsByClassName('txtInput')[0];
	(function getString() {
		setTimeout(function() {
			counter++;
			inputBox.value += fullText[counter];
			inputBox.dispatchEvent(new KeyboardEvent("keydown", {key: 'x'}))
			if(counter != fullText.length - 1) {
				getString();
			}
		}, time);
	})()
}
