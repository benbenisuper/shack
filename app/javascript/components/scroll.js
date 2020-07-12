const scrollLastMessageIntoView = () => {
  const messages = document.querySelectorAll('.message');
  if (messages) {
	  const lastMessage = messages[messages.length - 1];
	  if (lastMessage) {
		  lastMessage.scrollIntoView(({ behavior: 'smooth', block: 'nearest', inline: 'start' }));
	  }
  }
}

export { scrollLastMessageIntoView };
