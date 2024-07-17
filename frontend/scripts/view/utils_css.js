

export function animateElementsOnLoad() {
    gsap.from("header", { opacity: 0, y: -50, duration: 1, ease: "power3.out" });
    gsap.from("h2", { opacity: 0, x: -50, duration: 1, delay: 0.3, ease: "power3.out" });
    gsap.from(".chat-input", { opacity: 0, y: 50, duration: 1, delay: 0.6, ease: "power3.out" });
    gsap.from("#addContentBtn", { opacity: 0, y: 50, duration: 1, delay: 0.9, ease: "power3.out" });
    gsap.from("#recentChats", { opacity: 0, stagger: 0.1, duration: 1, delay: 1.2, ease: "power3.out" });
}
