import { renderMathJax, renderKaTeX, latex_formatting, checkString} from './latex_utils.js';
import { animateElementsOnLoad  } from './utils_css.js';
import { displayRecentProjects  } from './utils_html.js';

export class View {
    constructor() {
        this.app = document.getElementById('app');
    }
    init() {
        this.createHeader();
        this.createGreeting();
        this.createChatContainer();
        this.createTypingIndicator();
        this.createChatInput();
        this.createAddContentButton();
        this.createRecentProjectsContainer();
        this.animateElementsOnLoad();
    }

    createRecentProjectsContainer() {
        const recentProjects = document.createElement('div');
        recentProjects.innerHTML = `
            <h3 class="text-xl font-semibold mb-6 flex items-center">
                <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                Your previous requests
            </h3>
            <div id="recentChats" class="grid grid-cols-1 md:grid-cols-3 gap-6"></div>
        `;
        this.app.appendChild(recentProjects);
    }


    displayRecentProjects(projects) {
        displayRecentProjects(projects);

    }

    createHeader() {
        const header = document.createElement('header');
        header.className = 'flex justify-between items-center mb-8';
        header.innerHTML = `
            <h1 class="text-2xl font-bold text-gray-200">Linear Algebra Calculator</h1>
            <div class="flex items-center space-x-4">
                <span class="text-sm text-gray-400">Demo version</span>
                <button id="upgradeBtn" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full transition duration-300 ease-in-out transform hover:scale-105">Potential Feature</button>
            </div>
        `;
        this.app.appendChild(header);
    }

    createGreeting() {
        const greeting = document.createElement('h2');
        greeting.className = 'text-4xl font-light mb-10 flex items-center';
        greeting.innerHTML = `
            <span class="text-orange-400 mr-3 star text-5xl">✻</span>
            <span id="greeting">Welcome</span>
        `;
        this.app.appendChild(greeting);
    }

    createChatContainer() {
        console.log('Creating chat container');
        const chatContainer = document.createElement('div');
        chatContainer.id = 'chatContainer';
        chatContainer.className = 'mb-8 space-y-4 overflow-y-auto rounded-lg';
        chatContainer.style.padding = '16px';
        this.app.appendChild(chatContainer);
        console.log('Chat container created:', chatContainer);
    }

    createChatInput() {
        console.log('Creating chat input');
        const chatInput = document.createElement('div');
        chatInput.className = 'chat-input rounded-xl p-4 mb-8 focus-within:ring-2 focus-within:ring-purple-500';
        chatInput.innerHTML = `
            <textarea id="userInput" rows="1" placeholder="Describe your matrix and clarify what property you are interested in." class="w-full bg-transparent outline-none text-lg resize-none overflow-hidden"></textarea>
            <div class="flex justify-between items-center mt-3 text-sm text-gray-400">
                <span class="flex items-center">
                    <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd"></path></svg>
                    GPT-4-Turbo
                </span>
                <span>Use shift + return for new line</span>
            </div>
        `;
        this.app.appendChild(chatInput);
        console.log('Chat input created:', chatInput);
    }

    createTypingIndicator() {
        const typingIndicator = document.createElement('div');
        typingIndicator.id = 'typingIndicator';
        typingIndicator.className = 'text-gray-400 mb-4';
        typingIndicator.innerHTML = 'Linear Algebra Calculator is working<span class="typing-animation">.</span><span class="typing-animation">.</span><span class="typing-animation">.</span>';
        this.app.appendChild(typingIndicator);
    }

    setupChatEventListeners(handleSubmit) {
        const textarea = document.getElementById('userInput');
        if (!textarea) {
            console.error('Textarea element not found');
            return;
        }
        textarea.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                const message = textarea.value.trim();
                if (message) {
                    handleSubmit(message);
                    textarea.value = '';
                    this.adjustTextareaHeight(textarea);
                }
            }
        });
        textarea.addEventListener('input', () => this.adjustTextareaHeight(textarea));
    }


    adjustTextareaHeight(textarea) {
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
    }

    createAddContentButton() {
        const addContentBtn = document.createElement('div');
        addContentBtn.className = 'mb-10';
        addContentBtn.innerHTML = `
            <p class="text-sm text-gray-400 mb-3">Perform Matrix Calculations</p>
            <button id="addContentBtn" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-lg transition duration-300 ease-in-out flex items-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                Another Potential Feature
            </button>
        `;
        this.app.appendChild(addContentBtn);
    }

    createRecentProjects() {
        console.log('Creating recent projects');
        const recentProjects = document.createElement('div');
        recentProjects.innerHTML = `
            <h3 class="text-xl font-semibold mb-6 flex items-center">
                <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                Your recent projects
            </h3>
            <div id="recentChats" class="grid grid-cols-1 md:grid-cols-3 gap-6"></div>
        `;
        this.app.appendChild(recentProjects);
    
        const recentChatsContainer = recentProjects.querySelector('#recentChats');
        const recentChats = [
            { title: "Project 1", time: "1 months ago" },
            { title: "Project 2", time: "2 months ago" },
            { title: "Project 3", time: "3 months ago" },
            { title: "Project 4", time: "6 months ago" },
            { title: "Project 5", time: "9 months ago" },
            { title: "Project 6", time: "10 months ago" }
        ];
    
        recentChats.forEach(chat => {
            const div = document.createElement('div');
            div.className = 'recent-chat p-4 rounded-xl';
            div.innerHTML = `
                <h4 class="font-semibold mb-2">${chat.title}</h4>
                <p class="text-sm text-gray-400">${chat.time}</p>
            `;
            recentChatsContainer.appendChild(div);
        });
    }

    animateElementsOnLoad() {
        animateElementsOnLoad();
    }

    renderMathJax() {
        MathJax.typesetPromise().then(() => {
            console.log('MathJax typesetting complete');
        }).catch((err) => {
            console.log('MathJax typesetting failed: ', err);
        });
    }
    
    // Function to render LaTeX with KaTeX
    renderKaTeX() {
        document.querySelectorAll('.katex-display, .katex-inline').forEach(function(el) {
            katex.render(el.textContent, el, {
                throwOnError: false,
                displayMode: el.classList.contains('katex-display')
            });
        });
    }

    // Additional methods for chat functionality
    addMessageToChat(sender, content) {
        if (!content) {
            console.error('Content is undefined or null');
            return;
        }
    
        content = latex_formatting(checkString(content))
         
        // Correct LaTeX matrix formatting (example)
    

        const chatContainer = document.getElementById('chatContainer');
        const messageDiv = document.createElement('div');
        messageDiv.className = `chat-message ${sender === 'user' ? 'text-right' : 'text-left'} mb-4`;
        messageDiv.innerHTML = `
            <div class="${sender === 'user' ? 'bg-purple-600' : 'bg-gray-700'} inline-block rounded-lg p-3 max-w-3/4 text-white">
                ${marked.parse(content)}
            </div>
        `;
        chatContainer.appendChild(messageDiv);

        gsap.fromTo(messageDiv, 
            { opacity: 0, y: 20 }, 
            { opacity: 1, y: 0, duration: 0.5, ease: "power3.out" }
        );

        chatContainer.scrollTop = chatContainer.scrollHeight;
        //renderMathJax();
        //renderKaTeX();
    }

    setTypingIndicatorVisibility(visible) {
        const typingIndicator = document.getElementById('typingIndicator');
        gsap.to(typingIndicator, { 
            opacity: visible ? 1 : 0, 
            duration: 0.3,
            onStart: () => {
                if (visible) typingIndicator.style.display = 'block';
            },
            onComplete: () => {
                if (!visible) typingIndicator.style.display = 'none';
            }
        });
    }

}
