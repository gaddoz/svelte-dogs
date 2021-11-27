<script lang="ts">
	import {onMount} from 'svelte';
	import {writable, derived} from 'svelte/store';

	/** Store for your data.
	**/
	export const apiData = writable([]);

	/** Data transformation.
	**/
	export const dogBreeds = derived(apiData, ($apiData) => {
		if ($apiData){
			return Object.keys($apiData).map(breed => breed);
		}
	return [];
	});

	onMount(async () => {
	fetch("https://dog.ceo/api/breeds/list/all")
	.then(response => response.json())
	.then(data => {
		apiData.set(data.message);
	}).catch(error => {
		console.log(error);
		return [];
	});
	});
</script>

<div class="dogs-breeds">
	<details>
		<summary class="h1">Dog Breeds</summary>
		<ul>
			{#each $dogBreeds as breed}
				<li>{breed}</li>
			{/each}
		</ul>
	</details>
</div>

<style>
	ul {
		list-style: none;
	}
	ul li {
		padding: 0.1rem;
	}
</style>
