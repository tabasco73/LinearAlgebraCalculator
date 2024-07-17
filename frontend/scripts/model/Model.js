import { sendMessage } from './backend_api.js';

export class Model {
    constructor() {
        this.chatHistory = [];
        this.recentProjects = [
            { title: "Placeholder 1", time: "1 month ago" },
            { title: "Placeholder 2", time: "2 months ago" },
            { title: "Placeholder 3", time: "3 months ago" },
            { title: "Placeholder 4", time: "6 months ago" },
            { title: "Placeholder 5", time: "9 months ago" },
            { title: "Placeholder 6", time: "10 months ago" }
        ];
    }

    addMessage(sender, content) {
        this.chatHistory.push({ sender, content });
    }

    getRecentProjects() {
        return this.recentProjects;
    }

    getChatHistory() {
        return this.chatHistory;
    }

    getLastMessage() {
        return this.chatHistory[this.chatHistory.length - 1];
    }

    async getChatbotResponse(message) {
        try {
            console.log('Sending message to chatbot:', message);
            const response = await sendMessage(message);
            console.log('Received response from chatbot:', response);
            return response;
        } catch (error) {
            console.error('Error in getChatbotResponse:', error);
            throw error;
        }
    }
}