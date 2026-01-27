const app = Vue.createApp({
	data() {
		return {
			MyName: 'Paul Overbeck',
			RoundUp: 'Any Questions ?',
			Age: 30,
			ImageLink: 'https://plus.unsplash.com/premium_photo-1688645554172-d3aef5f837ce?q=80&w=1752&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
		}
	},
	methods:{
		multi(number) {
			return this.Age + number;
		},
		fk_random(){
			return Math.random() < 0.5 ? 1 : 0;
		}
	}
});

app.mount('#assignment');