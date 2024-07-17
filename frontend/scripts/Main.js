import { Model } from './model/Model.js';
import { View } from './view/View.js';
import { Controller } from './Controller.js';

class ClaudeApp {
    constructor() {
        this.model = new Model();
        this.view = new View();
        this.controller = new Controller(this.model, this.view);
    }

    init() {
        this.controller.init();
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const app = new ClaudeApp();
    app.init();
});