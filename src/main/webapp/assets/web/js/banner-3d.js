/**
 * Fruitables 3D Interactive Banner Engine
 * High-performance 60FPS mouse tilt & parallax depth system
 */
(function() {
    'use strict';

    function init3DTilt() {
        const tiltCards = document.querySelectorAll('[data-3d-tilt]');
        if (!tiltCards.length) return;

        const isTouchDevice = ('ontouchstart' in window) || (navigator.maxTouchPoints > 0);

        tiltCards.forEach(card => {
            const maxTilt = parseFloat(card.dataset.tiltMax) || 12;
            const perspective = card.dataset.tiltPerspective || '1000px';
            const scale = parseFloat(card.dataset.tiltScale) || 1.02;

            let rafId = null;
            let currentX = 0;
            let currentY = 0;
            let targetX = 0;
            let targetY = 0;
            let isHovered = false;

            const parentContainer = card.closest('.tilt-3d-stage') || card;

            function updateTilt() {
                // Smooth linear interpolation (lerp) for springy motion
                currentX += (targetX - currentX) * 0.12;
                currentY += (targetY - currentY) * 0.12;

                if (isHovered) {
                    card.style.transform = `perspective(${perspective}) rotateX(${currentX.toFixed(2)}deg) rotateY(${currentY.toFixed(2)}deg) scale3d(${scale}, ${scale}, ${scale})`;
                } else {
                    card.style.transform = `perspective(${perspective}) rotateX(${currentX.toFixed(2)}deg) rotateY(${currentY.toFixed(2)}deg) scale3d(1, 1, 1)`;
                }

                // If still moving or hovered, keep animating
                if (isHovered || Math.abs(targetX - currentX) > 0.05 || Math.abs(targetY - currentY) > 0.05) {
                    rafId = requestAnimationFrame(updateTilt);
                } else {
                    card.style.transform = `perspective(${perspective}) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)`;
                    rafId = null;
                }
            }

            if (!isTouchDevice) {
                parentContainer.addEventListener('mousemove', function(e) {
                    const rect = parentContainer.getBoundingClientRect();
                    const centerX = rect.left + rect.width / 2;
                    const centerY = rect.top + rect.height / 2;

                    const mouseX = e.clientX - centerX;
                    const mouseY = e.clientY - centerY;

                    // Calculate rotation angles (inverted Y for intuitive feel)
                    targetX = (-mouseY / (rect.height / 2)) * maxTilt;
                    targetY = (mouseX / (rect.width / 2)) * maxTilt;

                    isHovered = true;
                    if (!rafId) {
                        rafId = requestAnimationFrame(updateTilt);
                    }
                });

                parentContainer.addEventListener('mouseleave', function() {
                    targetX = 0;
                    targetY = 0;
                    isHovered = false;
                    if (!rafId) {
                        rafId = requestAnimationFrame(updateTilt);
                    }
                });

                parentContainer.addEventListener('mouseenter', function() {
                    isHovered = true;
                });
            } else {
                // Trên thiết bị cảm ứng, giữ chuyển động lơ lửng tự nhiên 3D
                card.classList.add('animate-float-3d');
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init3DTilt);
    } else {
        init3DTilt();
    }

    window.initFruitables3DBanners = init3DTilt;
})();
