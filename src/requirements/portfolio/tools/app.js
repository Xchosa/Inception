const app = Vue.createApp({
	data() {
		return {
			MyName: 'Paul Overbeck',
			git_sap_sit: 'https://github.com/vishnudevramachandra/sap-sit',
			gitDataIntellegence: 'https://github.com/Xchosa/Data-Intelligence.git',
			ImageLink: 'https://plus.unsplash.com/premium_photo-1688645554172-d3aef5f837ce?q=80&w=1752&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
			gitMinishell: 'https://github.com/Xchosa/minishell.git',
		}
	},

	methods:{
		Data_Intelligence() {
      		window.open(this.gitDataIntellegence, '_blank');
    	},
		SAP_StackIT_Challange() {
			window.open(this.git_sap_sit, '_blank');
		},
		minishell() {
			window.open(this.minishell , '_blank');
		}
	}
});

app.mount('#assignment');