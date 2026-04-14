<script setup>
    import ContactForm from '../components/Form.vue'
</script>

<template>
    <div class="grid grid-cols-3">
        <div class="animated-gradient rounded-4xl p-10 m-4 text-white h-[45rem] flex flex-col justify-between shadow-lg hover:shadow-xl transition-shadow">
            <div>
                <h1 class="text-4xl font-bold mb-4">Contact Us</h1>
                <p class="text-gray-100 mb-6 leading-relaxed">Have questions or feedback ? We'd love to hear from you !</p>
                <div class="space-y-3 mt-4">
                    <p class="text-gray-200 font-semibold">Reach us at:</p>
                    <p class="text-gray-100 flex items-center">
                        <span class="mr-3">📧</span>
                        <span>info@phantomwaves.com</span>
                    </p>
                    <p class="text-gray-100 flex items-center">
                        <span class="mr-3">📱</span>
                        <span>(123) 456-7890</span>
                    </p>
                </div>
            </div>
            <p class="text-gray-200 pt-6 border-t border-white/20 italic">Your review is important to us ! It helps us improve our services.</p>
        </div>
        <ContactForm type="contact"/>
        <div class="bg-white rounded-4xl p-10 m-4 text-black h-[45rem] flex flex-col justify-start overflow-y-auto">
            <h1 class="text-4xl font-bold mb-6">Frequently Asked Questions</h1>
            <div class="space-y-4">
                <div class="border-l-4 border-blue-500 pl-4 py-2">
                    <p class="font-semibold text-blue-600 mb-1">Q: How can I create an account ?</p>
                    <p class="text-gray-700">A: Click on the "Sign Up" button on the top right corner and fill in the required information.</p>
                </div>
                <div class="border-l-4 border-blue-500 pl-4 py-2">
                    <p class="font-semibold text-blue-600 mb-1">Q: How do I reset my password ?</p>
                    <p class="text-gray-700">A: Click on the "Forgot Password" link on the login page and follow the instructions.</p>
                </div>
                <div class="border-l-4 border-blue-500 pl-4 py-2">
                    <p class="font-semibold text-blue-600 mb-1">Q: How can I contact customer support ?</p>
                    <p class="text-gray-700">A: You can reach us via the contact form on this page or email us at info@phantomwaves.com</p>
                </div>
            </div>
        </div>
    </div>
</template>