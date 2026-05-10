<script setup>
import { computed, onMounted, ref } from 'vue';
import { getGenres } from '../store/Song';

const genres = ref([]);
const isLoading = ref(false);
const errorMessage = ref('');
const selectedGenreId = ref(null);

const quizStarted = ref(false);
const quizQuestion = ref(null);
const quizOptions = ref([]);
const selectedAnswer = ref('');
const quizFeedback = ref('');
const quizCorrectCount = ref(0);
const quizTotalCount = ref(0);

const selectedGenre = computed(() => {
	return genres.value.find((genre) => genre.idGenre === selectedGenreId.value) || null;
});

const genreNames = computed(() => genres.value.map((genre) => genre.name));

const quizPool = computed(() => {
	return genres.value.flatMap((genre) => {
		const examples = Array.isArray(genre.examples) ? genre.examples : [];
		return examples.map((song) => ({
			title: song.title,
			genreName: genre.name,
		}));
	});
});

const randomItem = (arr) => arr[Math.floor(Math.random() * arr.length)];

const shuffle = (arr) => {
	const copy = [...arr];
	for (let i = copy.length - 1; i > 0; i -= 1) {
		const j = Math.floor(Math.random() * (i + 1));
		[copy[i], copy[j]] = [copy[j], copy[i]];
	}
	return copy;
};

const buildQuizQuestion = () => {
	if (quizPool.value.length === 0 || genreNames.value.length === 0) {
		quizQuestion.value = null;
		quizOptions.value = [];
		return;
	}

	const question = randomItem(quizPool.value);
	const wrongAnswers = shuffle(genreNames.value.filter((name) => name !== question.genreName)).slice(0, 3);
	quizQuestion.value = question;
	quizOptions.value = shuffle([question.genreName, ...wrongAnswers]);
	selectedAnswer.value = '';
	quizFeedback.value = '';
};

const startQuiz = () => {
	quizStarted.value = true;
	quizCorrectCount.value = 0;
	quizTotalCount.value = 0;
	buildQuizQuestion();
};

const submitQuizAnswer = () => {
	if (!quizQuestion.value || !selectedAnswer.value) return;

	quizTotalCount.value += 1;
	if (selectedAnswer.value === quizQuestion.value.genreName) {
		quizCorrectCount.value += 1;
		quizFeedback.value = 'Correct ! Great ear !';
		return;
	}

	quizFeedback.value = `Not this time. Correct answer: ${quizQuestion.value.genreName}.`;
};

const nextQuizQuestion = () => {
	buildQuizQuestion();
};

const selectGenre = (idGenre) => {
	selectedGenreId.value = idGenre;
};

const loadGenres = async () => {
	isLoading.value = true;
	errorMessage.value = '';

	try {
		genres.value = await getGenres();
		if (genres.value.length > 0) {
			selectedGenreId.value = genres.value[0].idGenre;
		}
	} catch (error) {
		console.error('Error fetching genres:', error);
		errorMessage.value = 'Unable to load genres for now. Please try again later.';
	} finally {
		isLoading.value = false;
	}
};

onMounted(() => {
	loadGenres();
});
</script>

<template>
	<section class="p-4 sm:p-8 lg:p-10">
		<div class="mb-6 sm:mb-10">
			<h2 class="text-2xl sm:text-4xl font-black tracking-wide">Music Genres Guide</h2>
			<p class="text-sm sm:text-base text-gray-300 mt-2 max-w-6xl leading-relaxed">
				Browse major music genres used all around the world. Click on any genre name to open a full description and discover example songs linked to that style.
			</p>
		</div>

		<div v-if="isLoading" class="text-base sm:text-lg font-semibold text-gray-300">
			Loading genres...
		</div>

		<div v-else-if="errorMessage" class="bg-red-950/60 border border-red-500 rounded-xl p-4 sm:p-5 text-red-100">
			{{ errorMessage }}
		</div>

		<div v-else class="space-y-8">
			<div class="grid grid-cols-1 lg:grid-cols-[0.35fr_0.65fr] gap-5 sm:gap-7">
				<aside class="rounded-2xl border border-gray-700 bg-zinc-950/90 p-3 sm:p-4">
					<p class="text-sm uppercase tracking-wide text-gray-400 mb-3">Click a genre</p>
					<div class="space-y-2 max-h-[420px] overflow-y-auto pr-1">
						<button
							v-for="genre in genres"
							:key="genre.idGenre"
							type="button"
							class="w-full text-left rounded-xl px-3 py-2 transition-colors duration-200 cursor-pointer"
							:class="selectedGenreId === genre.idGenre ? 'bg-emerald-700 text-white font-semibold' : 'bg-zinc-900 text-gray-200 hover:bg-zinc-800'"
							@click="selectGenre(genre.idGenre)"
						>
							{{ genre.name }}
						</button>
					</div>
				</aside>

				<article v-if="selectedGenre" class="rounded-2xl border border-gray-700 bg-gradient-to-br from-zinc-900 via-zinc-950 to-black p-5 sm:p-7 shadow-lg">
					<div class="flex items-center justify-between gap-4 mb-4">
						<h3 class="text-xl sm:text-3xl font-bold text-white">{{ selectedGenre.name }}</h3>
					</div>

					<p class="text-sm sm:text-base text-gray-300 leading-relaxed mb-6">
						{{ selectedGenre.description }}
					</p>

					<div>
						<h4 class="text-base sm:text-lg font-bold text-white mb-2">Example songs for this genre</h4>
						<ul v-if="selectedGenre.examples.length > 0" class="space-y-2">
							<li
								v-for="song in selectedGenre.examples"
								:key="song.idSong"
								class="rounded-lg border border-zinc-700 bg-zinc-900/70 px-3 py-2 text-sm sm:text-base text-gray-200"
							>
								{{ song.title }}
								<span class="text-gray-400"> by {{ song.artist }}</span>
							</li>
						</ul>
						<p v-else class="text-sm text-gray-400">No example songs linked yet for this genre.</p>
					</div>
				</article>
			</div>

			<section class="rounded-2xl border border-gray-700 bg-zinc-950/90 p-5 sm:p-7">
				<div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
					<h3 class="text-lg sm:text-2xl font-bold text-white">Mini Quiz. Guess The Genre</h3>
					<p class="text-sm text-gray-300">Score: {{ quizCorrectCount }} / {{ quizTotalCount }}</p>
				</div>

				<div v-if="!quizStarted">
					<button
						type="button"
						class="px-4 py-2 rounded-lg bg-emerald-700 text-white font-semibold hover:bg-emerald-600 transition-colors duration-200 cursor-pointer"
						@click="startQuiz"
					>
						Start quiz
					</button>
				</div>

				<div v-else-if="quizQuestion" class="space-y-4">
					<p class="text-base sm:text-lg text-gray-100">
						Song: <span class="font-bold">{{ quizQuestion.title }}</span>
					</p>

					<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-2">
						<button
							v-for="option in quizOptions"
							:key="option"
							type="button"
							class="rounded-lg px-3 py-2 text-sm sm:text-base border transition-colors duration-200 cursor-pointer"
							:class="selectedAnswer === option ? 'border-emerald-500 bg-emerald-900/50 text-white' : 'border-zinc-700 bg-zinc-900 text-gray-200 hover:bg-zinc-800'"
							@click="selectedAnswer = option"
						>
							{{ option }}
						</button>
					</div>

					<div class="flex flex-wrap gap-2">
						<button
							type="button"
							class="px-4 py-2 rounded-lg bg-blue-700 text-white font-semibold hover:bg-blue-600 transition-colors duration-200 disabled:opacity-50 cursor-pointer"
							:disabled="!selectedAnswer"
							@click="submitQuizAnswer"
						>
							Submit answer
						</button>
						<button
							type="button"
							class="px-4 py-2 rounded-lg bg-zinc-700 text-white font-semibold hover:bg-zinc-600 transition-colors duration-200 cursor-pointer"
							@click="nextQuizQuestion"
						>
							Next song
						</button>
					</div>

					<p v-if="quizFeedback" class="text-sm sm:text-base text-emerald-300">
						{{ quizFeedback }}
					</p>
				</div>

				<p v-else class="text-sm text-gray-400">Quiz is not available because there are no song examples yet.</p>
			</section>
		</div>
	</section>
</template>
