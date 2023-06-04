
<!-- Limit unedited schools showing on dashboard home page to 9 -->	
<% loop $SchoolsUneditedForMonth.Limit(9) %>
    <div class="col-xl-4">
        <div class="card h-100">
            <div class="card-body">
                <h3 class="card-title h5"><a href="$DashboardLink">$Name</a></h3>
                <p>Engagement type: $Engagement.Title</p>
                <p>$Notes.Count note<% if $Notes.Count != 1 %>s<% end_if %></p>
            </div>
            <div class="card-footer">
                <span class="text-danger">Last updated $LastUpdated.Ago(false)</span>
            </div>
        </div>
    </div>
<% end_loop %>
<% if $SchoolsUneditedForMonth.Count > 9 %>
    <div class="card-footer mx-3">
        <a href="$Link(schools)?sortBy=LastUpdated&sortDirection=DESC&filter=&unedited=1" class="card-link">View all schools not updated for a month or more</a>
    </div>
<% end_if %>



<!-- Template files changed from SilverStripe to Vue sj in Dashboard-community.ss -->
<h1>Community of Practice</h1>

<div id="CommunityList">
	<div class="row mb-3 g-2">
		<div class="col-md-4">
			<p>See updates from the community of providers working to deliver Tūturu across the country.</p>
		</div>
		<div class="col-md-8 text-md-end">
			<a href="$Link('community/add')" class="btn btn-success">Share an update with the CoP</a>
		</div>
	</div>

	<div class="row">
		<div role="form" class="col-md-4 mb-2 mt-4">
			<label for="Filter" class="d-none">Filter CoP</label>
			<div class="search-input input-group">
				<input type="text" id="Filter" class="form-control border-0 form-control-sm search-focus" placeholder="Filter" :value="urlVars.filter" @change="urlVars.filter = \$event.target.value.trim()" aria-label="search">
				<button type="button" @click="urlVars.filter=''" v-if="urlVars.filter" class="btn border-0"><i class="icon-cross"></i></button>
			</div>
		</div>
	</div>

	<div class="my-3 row">
		<form class="col">
			<label for="SortCop">Sorted by: </label>
			<select id="SortCop" class="form-select form-select-sm mb-3 ms-2" @change="setSort(\$event.target)">
				<option data-col="date" data-direction="DESC" :selected="urlVars.sortBy=='date' && urlVars.sortDirection=='DESC'">Date (recent)</option>
				<option data-col="date" data-direction="ASC" :selected="urlVars.sortBy=='date' && urlVars.sortDirection=='ASC'">Date (oldest)</option>
				<option data-col="Title" data-direction="ASC"  :selected="urlVars.sortBy=='Title' && urlVars.sortDirection=='ASC'">A-Z</option>
				<option data-col="Title" data-direction="DESC"  :selected="urlVars.sortBy=='Title' && urlVars.sortDirection=='DESC'">Z-A</option>
			</select>
		</form>
	</div>

	<template v-if="communityList.length">
		<div class="row row-cols-1 row-cols-md-2 g-4" id="ScrollTop">
			<template v-for="c in paginatedList(communityList)">
				<div class="col-xl-4">
					<div class="card h-100">
						<div class="card-body">
						<span class="badge bg-primary mb-2"> {{ c.CommunityType }}</span>
							<h2 class="h3 card-title"><a :href="'/dashboard/community/view/' + c.ID" class="stretched-link">{{ c.Title }}</a></h2>
						</div>
						<div class="card-footer text-muted">
							<p>
							{{ c.CreatedBy }}<br>
							{{ c.Date }}
							</p>
						</div>
					</div>
				</div>
			</template>
		</div>
		<Pagination-Nav />
	</template>
	<template v-if="noResult">
		<h2>No results for this search criteria, please try again</h2>
	</template>

	<% include DashboardAjaxLoading %>

</div>



<!-- Template files changed from SilverStripe to Vue sj in Dashboard-providers-details.ss -->
<h1>$Provider.Title</h1>

<div id="ProviderSchools" data-provider-id="$Provider.ID">
	<div class="row">
		<div role="form" class="col-md-4 mb-2 mt-4">
			<label for="Filter" class="d-none">Filter schools</label>
			<div class="search-input input-group">
				<input type="text" id="Filter" class="form-control search-focus border-0 form-control-sm" placeholder="Filter" :value="urlVars.filter" @change="urlVars.filter = \$event.target.value.trim()" aria-label="search">
				<button type="button" @click="urlVars.filter=''" v-if="urlVars.filter" class="btn border-0"><i class="icon-cross"></i></button>
			</div>
		</div>
	</div>

	<div class="my-3 row">
		<form class="col">
			<label for="SortProviderSchools">Sorted by: </label>
			<select id="SortProviderSchools" class="form-select form-select-sm mb-3 ms-2" @change="setSort(\$event.target)">
				<option data-col="LastUpdated" data-direction="DESC" :selected="urlVars.sortBy=='LastUpdated' && urlVars.sortDirection=='DESC'">Last activity (recent)</option>
				<option data-col="LastUpdated" data-direction="ASC" :selected="urlVars.sortBy=='LastUpdated' && urlVars.sortDirection=='ASC'">Last activity (oldest)</option>
				<option data-col="SchoolInfo.Name" data-direction="ASC"  :selected="urlVars.sortBy=='SchoolInfo.Name' && urlVars.sortDirection=='ASC'">A-Z</option>
				<option data-col="SchoolInfo.Name" data-direction="DESC"  :selected="urlVars.sortBy=='SchoolInfo.Name' && urlVars.sortDirection=='DESC'">Z-A</option>
			</select>
		</form>
	</div>

	<template v-if="schools.length">
		<div class="row row-cols-1 row-cols-md-2 g-4">
			<template v-for="s in paginatedList(schools)">
				<div class="col-xl-4">
					<div class="card h-100">
						<div class="card-body">
							<h2 class="card-title h5">
								<a :href="s.Link" class="stretched-link"> {{ s.Name }} </a>
							</h2>
							<p class="mb-0">Engagement: {{ s.EngagementTitle }}</p>
							<p>
								{{ s.NoteCount }} note<template v-if="s.NoteCount != 1">s</template>,
								{{ s.ActionsCount }} open action<template v-if="s.ActionsCount != 1">s</template>
							</p>
						</div>
						<div class="card-footer small" :class="s.IsStale ? 'text-danger' : 'text-muted'">
							<template v-if="s.LastUpdated">
								Last updated {{ s.LastUpdated }}
							</template>
							<template v-else>No activity</template>
						</div>
					</div>
				</div>
			</template>
		</div>
		<Pagination-Nav />
	</template>
	<template v-if="noResult">
		<h2>No results for this search criteria, please try again</h2>
	</template>
</div>




<!-- Template files changed from SilverStripe to Vue sj in Dashboard-providers.ss -->
<h1>Tūturu Health providers</h1>

<div id="Providers">
	<div class="row">
		<div role="form" class="col-md-4 mb-2 mt-4">
			<label for="Filter" class="d-none">Filter providers</label>
			<div class="search-input input-group">
				<input type="text" id="Filter" class="form-control search-focus border-0 form-control-sm" placeholder="Filter" :value="urlVars.filter" @change="urlVars.filter = \$event.target.value.trim()" aria-label="search">
				<button type="button" @click="urlVars.filter=''" v-if="urlVars.filter" class="btn border-0"><i class="icon-cross"></i></button>
			</div>
		</div>
	</div>

	<div class="my-3 row">
		<form class="col">
			<label for="SortProvider">Sorted by: </label>
			<select id="SortProvider" class="form-select form-select-sm mb-3 ms-2" @change="setSort(\$event.target)">
				<option data-col="LastUpdated" data-direction="DESC" :selected="urlVars.sortBy=='LastUpdated' && urlVars.sortDirection=='DESC'">Last activity (recent)</option>
				<option data-col="LastUpdated" data-direction="ASC" :selected="urlVars.sortBy=='LastUpdated' && urlVars.sortDirection=='ASC'">Last activity (oldest)</option>
				<option data-col="Name" data-direction="ASC"  :selected="urlVars.sortBy=='Name' && urlVars.sortDirection=='ASC'">A-Z</option>
				<option data-col="Name" data-direction="DESC"  :selected="urlVars.sortBy=='Name' && urlVars.sortDirection=='DESC'">Z-A</option>
			</select>
		</form>
	</div>

	<template v-if="providers.length">
		<div class="row row-cols-1 row-cols-md-2 g-4">
			<template v-for="p in paginatedList(providers)">
				<div class="col-xl-4">
					<div class="card h-100">
						<div class="card-body">
							<h2 class="h3 card-title"><a :href="p.Link" class="stretched-link">{{ p.Name }} <i class="icon-triangle-right small"></i></a></h2>
							<p class="mb-0">Schools: {{ p.SchoolsCount }}</p>
							<p>Notes: {{ p.NotesCount }} </p>
						</div>
						<div class="card-footer small text-muted">
							<template v-if="p.LastUpdated">
								Last activity {{ p.LastUpdated }}
							</template>
							<template v-else>No activity</template>
						</div>
					</div>
				</div>
			</template>
		</div>
		<Pagination-Nav />
	</template>
	<template v-if="noResult">
		<h2>No results for this search criteria, please try again</h2>
	</template>

	<% include DashboardAjaxLoading %>

</div>


<!-- Template files changed from SilverStripe to Vue sj in Dashboard-schools.ss -->
<h1>Schools page</h1>

<div id="AllSchools">
	<div class="row">
		<div role="form" class="col-md-4 mb-2 mt-4">
			<label for="Filter" class="d-none">Filter schools</label>
			<div class="search-input input-group">
				<input type="text" id="Filter" class="form-control search-focus border-0 form-control-sm" placeholder="Filter" :value="urlVars.filter" @change="urlVars.filter = \$event.target.value.trim()" aria-label="search">
				<button type="button" @click="urlVars.filter=''" v-if="urlVars.filter" class="btn border-0"><i class="icon-cross"></i></button>
			</div>
		</div>
	</div>

	<span class="text-muted small">
		<p class="d-none d-md-inline-block text-muted pe-2 pt-4">Filter schools that: </p>
	</span>
	<button  id="unedited"class="btn btn-sm" :class="urlVars.unedited ? 'btn-candy': 'btn-outline-candy-dark'"
		v-on:click="urlVars.unedited = !urlVars.unedited" @change="setSort(\$event.target)">
		<span class="icon-triangle-right small"></span> Have no recent updates
	</button>

	<div class="my-3 row">
		<form class="col">
			<label for="SortSchools">Sorted by: </label>
			<select id="SortSchools" class="form-select form-select-sm mb-3 ms-2" @change="setSort(\$event.target)">
				<option data-col="LastUpdated" data-direction="DESC" :selected="urlVars.sortBy=='LastUpdated' && urlVars.sortDirection=='DESC'">Last activity (recent)</option>
				<option data-col="LastUpdated" data-direction="ASC" :selected="urlVars.sortBy=='LastUpdated' && urlVars.sortDirection=='ASC'">Last activity (oldest)</option>
				<option data-col="SchoolInfo.Name" data-direction="ASC"  :selected="urlVars.sortBy=='SchoolInfo.Name' && urlVars.sortDirection=='ASC'">A-Z</option>
				<option data-col="SchoolInfo.Name" data-direction="DESC"  :selected="urlVars.sortBy=='SchoolInfo.Name' && urlVars.sortDirection=='DESC'">Z-A</option>
			</select>
		</form>
	</div>

	<template v-if="schools.length">
		<div class="row row-cols-1 row-cols-md-2 g-4">
			<template v-for="s in paginatedList(filteredView)">
				<div class="col-xl-4">
					<div class="card h-100">
						<div class="card-body">
							<h2 class="h3 card-title">
								<a :href="s.Link" class="stretched-link">{{ s.Name }}<i class="icon-triangle-right small"></i></a>
							</h2>
							<p class="mb-0">Engagement: {{ s.EngagementTitle }}</p>
							<p class="small">
								{{ s.NoteCount }} note<template v-if="s.NoteCount != 1">s</template>,
								{{ s.ActionsCount }} open action<template v-if="s.ActionsCount != 1">s</template>
							</p>
						</div>
						<div class="card-footer small" :class="s.IsStale ? 'text-danger' : 'text-muted'">
							<template v-if="s.LastUpdated" >
								Last activity {{ s.LastUpdated }}
							</template>
							<template v-else>No activity</template>
						</div>
					</div>
				</div>
			</template>
		</div>

		<Pagination-Nav />

	</template>
	<div class="col" v-if="noResult">
		<h2>No results for this search criteria, please try again</h2>
	</div>
	<% include DashboardAjaxLoading %>
</div>
