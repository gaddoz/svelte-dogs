<script context="module" lang="ts">
	export const prerender = true;
</script>

<script lang="ts">
	import DogsRandomDog from '$lib/DogsRandomDog.svelte';
	import DogsBreeds from '$lib/DogsBreeds.svelte';

</script>

<svelte:head>
	<title>Home</title>
</svelte:head>

<section>

	<h1>svelte dogs</h1>

	<DogsRandomDog />
	<DogsBreeds />

</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		flex: 1;
	}

	h1 {
		width: 100%;
	}

</style>
