export class Controller {
    constructor(model, view) {
        this.model = model;
        this.view = view;
    }

    init() {
        this.view.init();
        this.setupEventListeners();
        this.displayRecentProjects();
    }

    setupEventListeners() {
        this.view.setupChatEventListeners(this.handleChatSubmit.bind(this));

        const addContentBtn = document.getElementById('addContentBtn');
        if (addContentBtn) {
            addContentBtn.addEventListener('click', () => {
                alert('Add content feature coming soon!');
            });
        }

        const upgradeBtn = document.getElementById('upgradeBtn');
        if (upgradeBtn) {
            upgradeBtn.addEventListener('click', () => {
                alert('Upgrade feature coming soon!');
            });
        }
    }

    displayRecentProjects() {
        const projects = this.model.getRecentProjects();
        this.view.displayRecentProjects(projects);
    }

    handleChatSubmit(message) {
        this.model.addMessage('user', message);
        this.view.addMessageToChat('user', message);
        this.simulateResponse(message);
    }

    async simulateResponse(message) {
        this.view.setTypingIndicatorVisibility(true);
        try {
            const response1 = await this.model.getChatbotResponse(message);
            const response = [{ prompt, answer: response1}];
            setTimeout(() => {
                this.view.setTypingIndicatorVisibility(false);
                if (response && response.length > 0) {
                    for (const resp of response) {
                        this.model.addMessage('claude', resp.answer);
                        this.view.addMessageToChat('claude', resp.answer);
                    }
                } else {
                    throw new Error('Empty response from chatbot');
                }
            }, 2000);
        } catch (error) {
            console.error('Error in simulateResponse:', error);
            this.view.setTypingIndicatorVisibility(false);
            this.view.addMessageToChat('claude', `I apologize, but I encountered an error: ${error.message}. Please try again.`);
        }
    }
}