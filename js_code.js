//Vue js code produced for Springtimesoft


// ============ JS CODE FROM COMMUNITY.JS ============ //
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import mixinCommon from './mixin-common.js';
import urlVarsMixin from './mixin-urlvars.js';
import paginationMixin from './mixin-pagination.js';

createApp({

    mixins: [mixinCommon, urlVarsMixin, paginationMixin],

    components: [paginationMixin],

    data() {
        return {
            urlVars: {
                sortBy: 'date',
                sortDirection: 'DESC',
                filter: '',
            },
            communityList: [],
            noResult: false,
            // scroll to the top of this element when a page changes
            paginationScrollToEl: '#ScrollTop',
        }
    },

    mounted: function () {
        this.getData();
    },

    methods: {
        // set cops sorting variables - getData() is automatically called via urlVarsOnAfterUpdate()
        setSort: function (el) {
            let o = el.options[el.selectedIndex];
            if (!o) {
                return;
            }
            // if el has selected option
            let sortCol = o.dataset.col;
            let sortDirection = o.dataset.direction;

            if (sortCol) {
                this.urlVars.sortBy = sortCol;
            }
            if (sortDirection) {
                this.urlVars.sortDirection = sortDirection;
            }
        },

        getData: function () {
            let self = this;
            let data = {};
            data.col = this.urlVars.sortBy;
            data.direction = this.urlVars.sortDirection;
            data.filter = this.urlVars.filter.trim();

            self.post('/dashboard/api/communityList/communityList/', data, function (response) {
                self.communityList = response.data;
                self.noResult = self.communityList.length == 0;
            });
        },

        // manually invoke this.getData() after URL vars change
        urlVarsOnAfterUpdate: function () {
            this.getData();
            // reset pagination to page 1
            this.paginationReset();
        },

    }
}).mount('#CommunityList')



// ============ JS CODE FROM PROVIDERS.JS ============ //
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import mixinCommon from './mixin-common.js';
import urlVarsMixin from './mixin-urlvars.js';
import paginationMixin from './mixin-pagination.js';

createApp({

    mixins: [mixinCommon, urlVarsMixin, paginationMixin],

    components: [paginationMixin],

    data() {
        return {
            urlVars: {
                sortBy: 'LastUpdated',
                sortDirection: 'DESC',
                filter: '',
            },
            providers: [],
            noResult: false,
            paginationScrollToEl: '#Providers',
        }
    },

    mounted: function () {
        this.getData();
        // scroll to the top of this element when a page changes
        this.paginationScrollToEl = '#Providers';
    },

    methods: {
        // set provider sorting variables - getData() is automatically called via urlVarsOnAfterUpdate()
        setSort: function (el) {
            let o = el.options[el.selectedIndex];
            if (!o) {
                return;
            }
            // if el has selected option
            let sortCol = o.dataset.col;
            let sortDirection = o.dataset.direction;

            if (sortCol) {
                this.urlVars.sortBy = sortCol;
            }
            if (sortDirection) {
                this.urlVars.sortDirection = sortDirection;
            }
        },

        getData: function () {
            let self = this;
            let data = {};
            data.col = this.urlVars.sortBy;
            data.direction = this.urlVars.sortDirection;
            data.filter = this.urlVars.filter.trim();

            self.post('/dashboard/api/providers/listProviders/', data, function (response) {
                self.providers = response.data;
                self.noResult = self.providers.length == 0;
            });
        },

        // manually invoke this.sortLogs() after URL vars change
        urlVarsOnAfterUpdate: function () {
            this.getData();
            // reset pagination to page 1
            this.paginationReset();
        },

    }
}).mount('#Providers')




// ============ JS CODE FROM SCHOOLS.JS ============ //
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import mixinCommon from './mixin-common.js';
import urlVarsMixin from './mixin-urlvars.js';
import paginationMixin from './mixin-pagination.js';

createApp({

    mixins: [mixinCommon, urlVarsMixin, paginationMixin],

    components: [paginationMixin],

    data() {
        return {
            urlVars: {
                sortBy: 'LastUpdated',
                sortDirection: 'DESC',
                filter: '',
                unedited: 0,
            },
            schools: [],
            noResult: 0,
            paginationScrollToEl: '#AllSchools',
        }
    },

    mounted: function () {
        this.getData();
    },

    computed: {
        filteredView: function () {
            return this.schools;
        }
    },

    methods: {
        // set school sorting variables - getData() is automatically called via urlVarsOnAfterUpdate()
        setSort: function (el) {
            let o = el.options[el.selectedIndex];
            if (!o) {
                return;
            }
            // if el has selected option
            let sortCol = o.dataset.col;
            let sortDirection = o.dataset.direction;

            if (sortCol) {
                this.urlVars.sortBy = sortCol;
            }
            if (sortDirection) {
                this.urlVars.sortDirection = sortDirection;
            }
        },

        getData: function () {
            let self = this;
            let data = {};
            data.col = this.urlVars.sortBy;
            data.direction = this.urlVars.sortDirection;
            data.filter = this.urlVars.filter.trim();
            data.unedited = this.urlVars.unedited;

            self.post('/dashboard/api/schoolList/listAllSchools/', data, function (response) {
                self.schools = response.data;
                self.noResult = self.schools.length == 0;
            });
        },

        // manually invoke this.sortLogs() after URL vars change
        urlVarsOnAfterUpdate: function () {
            this.getData();
            this.paginationReset();
        },

    }
}).mount('#AllSchools')






// ============ JS CODE FROM SITE.JS WHERE THE SEARCH FIELD BORDER HAS BEEN ADDED ============ //
const searchFields = document.querySelectorAll("input.search-focus");
searchFields.forEach((el) => {
    el.addEventListener('focus', () => {
        el.parentElement.classList.add('focus');
    });
    el.addEventListener('blur', () => {
        el.parentElement.classList.remove('focus');
    });
});
