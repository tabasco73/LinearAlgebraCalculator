export function displayRecentProjects(projects) {
    const recentChatsContainer = document.getElementById('recentChats');
    recentChatsContainer.innerHTML = '';
    projects.forEach(project => {
        const div = document.createElement('div');
        div.className = 'recent-chat p-4 rounded-xl';
        div.innerHTML = `
            <h4 class="font-semibold mb-2">${project.title}</h4>
            <p class="text-sm text-gray-400">${project.time}</p>
        `;
        recentChatsContainer.appendChild(div);
    });
}