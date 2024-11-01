let cutscenes = [];

// Set cutscene options in the menu
function setCutsceneOptions(options) {
    cutscenes = options;
    const cutsceneList = document.getElementById('cutsceneList');
    cutsceneList.innerHTML = ''; // Clear existing items

    options.forEach(cutscene => {
        const li = document.createElement('li');
        li.textContent = cutscene.name;
        li.title = cutscene.description; // Show description as tooltip
        li.addEventListener('click', () => {
            fetch(`https://lfd-CutScenesViewer/playCutscene`, {
                method: 'POST',
                body: JSON.stringify({ cutsceneId: cutscene.id })
            });
        });
        cutsceneList.appendChild(li);
    });
}

// Function to open the menu with animation
function openMenu() {
    const menu = document.getElementById('menu');
    const overlay = document.getElementById('overlay');

    // Ensure menu and overlay are shown and not already displayed
    if (!menu.classList.contains('show')) {
        menu.classList.add('show'); // Show menu with animation
        overlay.classList.add('show'); // Show overlay with animation
    }
}

// Close menu button functionality
document.getElementById('closeMenu').addEventListener('click', () => {
    closeMenu();
});

function closeMenu() {
    const menu = document.getElementById('menu');
    const overlay = document.getElementById('overlay');

    if (menu.classList.contains('show')) {
        menu.classList.remove('show'); // Hide menu with animation
        overlay.classList.remove('show'); // Hide overlay with animation
        fetch(`https://lfd-CutScenesViewer/closeMenu`, { method: 'POST' });
    }
}

document.getElementById('stopScene').addEventListener('click', () => {
    fetch(`https://lfd-CutScenesViewer/stopScene`, { method: 'POST' });
    closeMenu(); // Optionally close the menu when stopping the scene
});

// Listen for messages from Lua to set options or show/hide the menu
window.addEventListener('message', (event) => {
    if (event.data.action === 'openMenu') {
        setCutsceneOptions(event.data.cutscenes);
        openMenu(); // Call openMenu to handle showing the menu
    } else if (event.data.action === 'closeMenu') {
        closeMenu(); // Call closeMenu to handle hiding the menu
    } else if (event.data.action === 'stopScene') {
        closeMenu(); // Call closeMenu to hide the menu when stopping the scene
    }
});

// Listen for the Escape key to close the menu
document.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        closeMenu(); // Call closeMenu to handle hiding the menu
        // Send message to the Lua script
        fetch('https://lfd-CutScenesViewer/onEscPressed', {
            method: 'POST',
            body: JSON.stringify({})
        });
    }
});
