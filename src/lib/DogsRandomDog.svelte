<script lang="ts">
	import {fade} from 'svelte/transition';
	let visible = false;
	let promise = loadRandomDog();
	async function loadRandomDog () {
		const response = await fetch('https://dog.ceo/api/breeds/image/random')
    	return await response.json()
	}
	function handleClick() {
		promise = loadRandomDog();
	}
</script>
<div class="dogs-random-dog">
	<details>
		<summary class="h1">Random Dog</summary>
		<div>
			{#await promise}
			<p transition:fade
				on:introstart={() => (visible = false)}
				on:outroend={() => (visible = true)}>
				...loading
			</p>
			{:then data}
				<img src={data.message} alt="Dog image" />
			{:catch error}
				<p>An error occurred!</p>
			{/await}
			<button on:click={handleClick}> load new random dog </button>
		</div>
	</details>
</div>

<style>
	img {
		max-width: 80vw;
		max-height: 30vh;
		margin: 0.5rem;
	}
	.dogs-random-dog div {
		display: flex;
		flex-direction: column;
		align-items: center;
	}
</style>
