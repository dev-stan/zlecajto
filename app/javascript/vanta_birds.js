
import "three";
import "vanta_birds";

function mountVantaBirds(element) {
  if (!element) return;
  if (element._vantaEffect) return; // Prevent double-mount
  if (window.VANTA && window.VANTA.BIRDS) {
    element._vantaEffect = window.VANTA.BIRDS({
      el: element,
      mouseControls: true,
      touchControls: true,
      gyroControls: false,
      minHeight: 200.00,
      minWidth: 200.00,
      scale: 1.00,
      scaleMobile: 1.00,
      backgroundColor: 0xffffff,
      color1: 0x1e293b,
      color2: 0x64748b,
      birdSize: 1.2,
      wingSpan: 20.0,
      speedLimit: 4.0,
      separation: 50.0,
      alignment: 50.0,
      cohesion: 50.0,
      quantity: 3
    });
  }
}

function destroyVantaBirds(element) {
  if (element && element._vantaEffect) {
    element._vantaEffect.destroy();
    element._vantaEffect = null;
  }
}

export { mountVantaBirds, destroyVantaBirds };
