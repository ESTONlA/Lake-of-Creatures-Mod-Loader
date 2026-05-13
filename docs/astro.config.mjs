import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://omegametor.github.io',
	base: '/LOCLM/',
	integrations: [
		starlight({
			title: 'LOCLM Documentation',
			social: {
				github: 'https://github.com/OmegaMetor/LOCLM',
			},
			editLink: {
				baseUrl: "https://github.com/OmegaMetor/LOCLM/edit/main/docs/"
			},
			sidebar: [
				{
					label: 'Guides',
					autogenerate: { directory: 'guides' }
				}
			],
		}),
	],

	// Process images with sharp: https://docs.astro.build/en/guides/assets/#using-sharp
	image: { service: { entrypoint: 'astro/assets/services/sharp' } },
});
