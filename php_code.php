<?php

//limit number of articles per page to 15
public function sortedSchools()
    {
        $schools = $this->member()->Schools();

        $sortedSchools = $this->getSortByLatest() ?
        $schools->sort('"LastUpdated"', 'DESC') : $schools;

        return PaginatedList::create(
            $sortedSchools,
            $this->getRequest()
        )->setPageLength(15);
    }

        public function sortedProviders()
    {
        $providers = Provider::get();

        $sortedProviders = $this->getSortByLatest() ?
        $providers->sort('"LastUpdated"', 'DESC') : $providers;

        return PaginatedList::create(
            $sortedProviders,
            $this->getRequest()
        )->setPageLength(15);
    }

            return PaginatedList::create(
            $communityPosts,
            $this->getRequest()
        )->setPageLength(15);



// ============= ProviderDetailesController.php ================== //
<?php

namespace Tuturu\Controllers\API;

use Tuturu\Controllers\BaseAPIController;
use Tuturu\Models\Provider;
use Tuturu\Models\School\School;

class ProviderDetailsController extends BaseAPIController
{
    /**
     * Allowed actions.
     *
     * @var array
     *
     * @config
     */
    private static $allowed_actions = [
        'listSchools',
        'listProviders',
    ];

    /**
     * URL handlers
     *
     * @var array
     */
    private static $url_handlers = [
        'listSchools/$ProviderID!' => 'listSchools',
        'listProviders'            => 'listProviders',
    ];

    /**
     * Controller init function
     *
     * @return void
     */
    public function init()
    {
        parent::init();

        if (!$this->isAdmin()) {
            return $this->JSONError('You do not have permission to view this', 401);
        }
    }

    /**
     * Listing schools from provider
     *
     * @param HTTPRequest $request HTTP request
     *
     * @return HTTPResponse
     */
    public function listSchools($request)
    {
        $providerID = $request->param('ProviderID');

        $provider = Provider::get()->byID($providerID);
        if (!$provider) {
            return $this->JSONError('Provider not found', 404);
        }

        $sortCol       = 'LastUpdated';
        $sortDirection = 'DESC';
        $filter        = '';

        $post = json_decode(file_get_contents('php://input'), true);
        if (is_array($post)) {
            if (in_array($this->arrayVal($post, 'col'), ['SchoolInfo.Name', 'LastUpdated'])) {
                $sortCol = $this->arrayVal($post, 'col');
            }

            if (in_array(strtolower($this->arrayVal($post, 'direction')), ['asc', 'desc'])) {
                $sortDirection = $this->arrayVal($post, 'direction');
            }

            $filter = trim($this->arrayVal($post, 'filter'));
        }

        $schools = $provider->Schools();
        if ($filter) {
            $schools = $schools->filter([
                'SchoolInfo.Name:PartialMatch' => $filter,
            ]);
        }
        $schools = $schools->sort($sortCol, $sortDirection);

        if (!$schools) {
            return $this->JSONError('Schools not found', 404);
        }

        $data = [];
        foreach ($schools as $s) {
            $date         = $s->dbObject('LastUpdated')->Ago();
            $actionsCount = 0;
            foreach ($s->Notes() as $n) {
                $actionsCount += $n->Actions()->Count();
            }
            $data[] = [
                'ID'              => $s->ID,
                'Name'            => $s->Name,
                'LastUpdated'     => $date,
                'NoteCount'       => $s->Notes()->Count(),
                'ActionsCount'    => $actionsCount,
                'EngagementTitle' => $s->Engagement()->Title,
                'Link'            => $s->dashboardLink(),
                'IsStale'         => $s->isStale(),
            ];
        }

        return $this->JSONResponse($data);
    }

    /**
     * List providers in sort order
     *
     * @param HTTPRequest $request HTTP request
     *
     * @return HTTPResponse
     */
    public function listProviders($request)
    {
        $sortCol       = 'LastUpdated';
        $sortDirection = 'DESC';
        $filter        = '';

        $post = json_decode(file_get_contents('php://input'), true);
        if (is_array($post)) {
            if (in_array($this->arrayVal($post, 'col'), ['Name', 'LastUpdated'])) {
                $sortCol = $this->arrayVal($post, 'col');
            }

            if (in_array(strtolower($this->arrayVal($post, 'direction')), ['asc', 'desc'])) {
                $sortDirection = $this->arrayVal($post, 'direction');
            }

            $filter = trim($this->arrayVal($post, 'filter'));
        }

        $providers = Provider::get();
        if ($filter) {
            $providers = $providers->filter([
                'Name:PartialMatch' => $filter,
            ]);
        }
        $providers = $providers->sort($sortCol, $sortDirection);

        if (!$providers) {
            return $this->JSONError('Providers not found', 404);
        }

        $data = [];
        foreach ($providers as $p) {
            $lastUpdated     = $p->dbObject('LastUpdated')->Ago();
            $noteCount       = 0;
            $providerSchools = School::get()->filter('ProviderID', $p->ID);
            if ($providerSchools) {
                foreach ($providerSchools as $providerSchool) {
                    $noteCount += $providerSchool->Notes()->Count();
                }
            }

            $data[] = [
                'ID'           => $p->ID,
                'Name'         => $p->Name,
                'SchoolsCount' => $p->Schools()->Count(),
                'LastUpdated'  => $lastUpdated,
                'NotesCount'   => $noteCount,
                'Link'         => '/dashboard/provider/view/' . $p->ID . '/',
            ];
        }

        return $this->JSONResponse($data);
    }
}


// ============= SchoolListController.php ================== //
<?php

namespace Tuturu\Controllers\API;

use Tuturu\Controllers\BaseAPIController;

class SchoolListController extends BaseAPIController
{
    /**
     * Allowed actions.
     *
     * @var array
     *
     * @config
     */
    private static $allowed_actions = [
        'listAllSchools',
    ];

    /**
     * URL handlers
     *
     * @var array
     */
    private static $url_handlers = [
        'listAllSchools' => 'listAllSchools',
    ];

    /**
     * Listing schools from provider
     *
     * @param HTTPRequest $request HTTP request
     *
     * @return HTTPResponse
     */
    public function listAllSchools($request)
    {
        $sortCol       = 'LastUpdated';
        $sortDirection = 'DESC';
        $filter        = '';
        $unedited      = 0;

        $post = json_decode(file_get_contents('php://input'), true);
        if (is_array($post)) {
            if (in_array($this->arrayVal($post, 'col'), ['SchoolInfo.Name', 'LastUpdated'])) {
                $sortCol = $this->arrayVal($post, 'col');
            }

            if (in_array(strtolower($this->arrayVal($post, 'direction')), ['asc', 'desc'])) {
                $sortDirection = $this->arrayVal($post, 'direction');
            }

            $filter   = trim($this->arrayVal($post, 'filter'));
            $unedited = ($this->arrayVal($post, 'unedited')) ? 1 : 0;
        }

        $schools = $this->member()->schools();
        if ($unedited) {
            $lastMonth = date('Y-m-d', strtotime('-30 days'));
            $schools   = $schools->filter([
                'LastUpdated:LessThan'         => $lastMonth,
                'SchoolInfo.Name:PartialMatch' => $filter,
            ])->sort(
                $sortCol,
                $sortDirection,
            );
        } else {
            if ($filter) {
                $schools = $schools->filter([
                    'SchoolInfo.Name:PartialMatch' => $filter,
                ]);
            }
            $schools = $schools->sort($sortCol, $sortDirection);
        }

        if (!$schools) {
            return $this->JSONError('Schools not found', 404);
        }

        $data = [];
        foreach ($schools as $s) {
            $date         = $s->dbObject('LastUpdated')->Ago();
            $actionsCount = 0;
            foreach ($s->Notes() as $n) {
                $actionsCount += $n->Actions()->Count();
            }
            $data[] = [
                'ID'              => $s->ID,
                'Name'            => $s->Name,
                'LastUpdated'     => $date,
                'NoteCount'       => $s->Notes()->Count(),
                'ActionsCount'    => $actionsCount,
                'EngagementTitle' => $s->Engagement()->Title,
                'Link'            => $s->dashboardLink(),
                'IsStale'         => $s->isStale(),
            ];
        }

        return $this->JSONResponse($data);
    }
}


// ============= CommunityListController.php ================== //
<?php

namespace Tuturu\Controllers\API;

use Tuturu\Controllers\BaseAPIController;
use Tuturu\Models\CommunityUpdate;

class CommunityListController extends BaseAPIController
{
    /**
     * Allowed actions.
     *
     * @var array
     *
     * @config
     */
    private static $allowed_actions = [
        'communityList',
    ];

    /**
     * URL handlers
     *
     * @var array
     */
    private static $url_handlers = [
        'communityList' => 'communityList',
    ];

    /**
     * Controller init function
     *
     * @return void
     */
    public function init()
    {
        parent::init();

        if (!$this->isAdmin()) {
            return $this->JSONError('You do not have permission to view this', 401);
        }
    }

    /**
     * Listing schools from provider
     *
     * @param HTTPRequest $request HTTP request
     *
     * @return HTTPResponse
     */
    public function communityList($request)
    {
        $sortCol       = 'date';
        $sortDirection = 'DESC';
        $filter        = '';

        $post = json_decode(file_get_contents('php://input'), true);
        if (is_array($post)) {
            if (in_array($this->arrayVal($post, 'col'), ['Title', 'date'])) {
                $sortCol = $this->arrayVal($post, 'col');
            }

            if (in_array(strtolower($this->arrayVal($post, 'direction')), ['asc', 'desc'])) {
                $sortDirection = $this->arrayVal($post, 'direction');
            }

            $filter = trim($this->arrayVal($post, 'filter'));
        }

        $communityList = CommunityUpdate::get()->filter('Approved', 1);
        if ($filter) {
            $communityList = $communityList->filter([
                'Title:PartialMatch' => $filter,
            ]);
        }
        $communityList = $communityList->sort($sortCol, $sortDirection);

        if (!$communityList) {
            return $this->JSONError('Community of Practice not found', 404);
        }

        $data = [];
        foreach ($communityList as $c) {
            $date = date('d M Y', strtotime($c->Date));

            $data[] = [
                'ID'            => $c->ID,
                'CommunityType' => $c->CommunityUpdateTypes->Title,
                'Title'         => $c->Title,
                'CreatedBy'     => $c->CreatedBy->Name,
                'Date'          => $date,
                'Link'          => '/dashboard/community/view/' . $c->ID . '/',
            ];
        }

        return $this->JSONResponse($data);
    }
}
