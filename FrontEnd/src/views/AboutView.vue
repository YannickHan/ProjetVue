<script setup>
import { onMounted } from "vue";
onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(({ target, isIntersecting }) => {
      target.classList.toggle("visible", isIntersecting);
    });
  }, { threshold: 0.2 });
  
  document.querySelectorAll(".reveal-wave").forEach(el => observer.observe(el));
});
</script>

<template>
    <div class="animated-gradient rounded-4xl p-10 m-4 text-white h-[45rem] flex flex-col justify-center">
        <div class="overflow-hidden">
            <div class="flex animate-marquee gap-2 opacity-70 w-max">
                <p class="text-4xl font-bold">
                    The Weeknd · Justin Bieber · Ariana Grande · Bruno Mars · Taylor Swift · Kanye West · Billie Eilish · Dua Lipa · Laufey · Sabrina Carpenter · Ado · imase · YOASOBI · Aimer · Eve · yama · LiSA ·
                </p>
                <p class="text-4xl font-bold">
                    The Weeknd · Justin Bieber · Ariana Grande · Bruno Mars · Taylor Swift · Kanye West · Billie Eilish · Dua Lipa · Laufey · Sabrina Carpenter · Ado · imase · YOASOBI · Aimer · Eve · yama · LiSA ·
                </p>
                <p class="text-4xl font-bold">
                    The Weeknd · Justin Bieber · Ariana Grande · Bruno Mars · Taylor Swift · Kanye West · Billie Eilish · Dua Lipa · Laufey · Sabrina Carpenter · Ado · imase · YOASOBI · Aimer · Eve · yama · LiSA ·
                </p>
            </div>
        </div>
        <h1 class="text-6xl font-bold text-center my-40">
            Turn waves into vibes ! 
            <span class="inline-block animate-bounce">😎</span>
        </h1>
        <div class="overflow-hidden">
            <div class="flex animate-marquee-reverse gap-2 opacity-80 w-max">
                <p class="text-3xl">
                  Stream new sounds. Discover rising artists. Find hidden gems first. Stream new sounds. Discover rising artists. Find hidden gems first.
                </p>
                <p class="text-3xl">
                  Stream new sounds. Discover rising artists. Find hidden gems first. Stream new sounds. Discover rising artists. Find hidden gems first.
                </p>
                <p class="text-3xl">
                  Stream new sounds. Discover rising artists. Find hidden gems first. Stream new sounds. Discover rising artists. Find hidden gems first.
                </p>
            </div>
        </div>
    </div>
    <div class="m-6 text-white relative overflow-hidden">
        <h1 class="text-5xl text-center font-bold mt-15 mb-20">About Phantom Waves</h1>
        <div class="max-w-7xl mx-auto space-y-20 mb-20">
            <p class="text-2xl relative px-6 py-[18px] opacity-0 bg-gradient-to-r from-white/0 via-white/10 to-white/0 translate-y-[30px] transition-all duration-[900ms] ease-[cubic-bezier(0.2,0.8,0.2,1)] band reveal-wave">
                Phantom Waves is a passion project by a group of music lovers and developers.
            </p>
            <p class="text-2xl relative px-6 py-[18px] opacity-0 bg-gradient-to-r from-white/0 via-white/10 to-white/0 translate-y-[30px] transition-all duration-[900ms] ease-[cubic-bezier(0.2,0.8,0.2,1)] band reveal-wave text-right">
                Built in 2026, it is a music streaming platform focused on discovery and personal taste.
            </p>
            <p class="text-2xl relative px-6 py-[18px] opacity-0 bg-gradient-to-r from-white/0 via-white/10 to-white/0 translate-y-[30px] transition-all duration-[900ms] ease-[cubic-bezier(0.2,0.8,0.2,1)] band reveal-wave">
                Designed to make music discovery effortless and instinctive.
            </p>
            <p class="text-2xl relative px-6 py-[18px] opacity-0 bg-gradient-to-r from-white/0 via-white/10 to-white/0 translate-y-[30px] transition-all duration-[900ms] ease-[cubic-bezier(0.2,0.8,0.2,1)] band reveal-wave text-right">
                Built for listeners who care about what they discover next.
            </p>
        </div>
    </div>
</template>

<style scoped>
/* ------ This handle scrolling animations in header ------ */

@keyframes marquee {
  0% { transform: translateX(0%); }
  100% { transform: translateX(-33.333%); }
}

@keyframes marquee-reverse {
  0% { transform: translateX(-33.333%); }
  100% { transform: translateX(0%); }
}

.animate-marquee {
  animation: marquee 35s linear infinite;
}

.animate-marquee-reverse {
  animation: marquee-reverse 25s linear infinite;
}

/* ------ This handle scrolling effect for about section ------ */

.band::before {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    rgba(255,255,255,0),
    rgba(255,255,255,0.08),
    rgba(255,255,255,0.25),
    rgba(255,255,255,0.08),
    rgba(255,255,255,0)
  );
  transform: translateX(-100%);
  transition: transform 1.2s ease;
}

.band.visible {
  opacity: 1;
  transform: none;
}

.band.visible::before {
  transform: translateX(100%);
}


/* ------ This handle heartbeat background ------ */

.m-6::before,
.m-6::after {
  content: "";
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml;utf8,<svg viewBox='0 0 600 130' xmlns='http://www.w3.org/2000/svg'><polyline points='0,60 30,60 45,60 60,10 75,110 90,60 105,60 120,35 135,95 150,60 165,60 180,15 195,105 210,60 225,60 240,20 255,100 270,60 285,60 300,5 315,115 330,60 345,60 360,30 375,90 390,60 405,60 420,15 435,105 450,60 465,60 480,25 495,95 510,60 525,60 540,10 555,110 570,60 585,60 600,60' fill='none' stroke='green' stroke-width='2'/></svg>");
  background-repeat: repeat-x;
  background-size: auto 100%;
  background-position: 0 75px;
  opacity: 0.08;
  pointer-events: none;
  will-change: transform;
}

@keyframes move1 {
  from { transform: translateX(0); }
  to   { transform: translateX(100%); }
}

@keyframes move2 {
  from { transform: translateX(-100%); }
  to   { transform: translateX(0); }
}

.m-6::before {
  animation: move1 8s linear infinite;
}

.m-6::after {
  transform: translateX(-100%);
  animation: move2 8s linear infinite;
}
</style>