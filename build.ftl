<!DOCTYPE html>
<html lang="en" ng-app="Klov">
	<#include 'partials/head.ftl'>
	<style>
		.border-box > h6 {
			margin-bottom: 20px;
		}
		.border-box {
		    border: 1px solid rgba(120,130,140,.2);
		    border-radius: .25rem;
		}
		.node.pass {
			background-color: #aed581;
		}
		.node.skip, .node.warning {
			background-color: #ff7043;
		}
		.node.fail, .node.error, .node.fatal {
			background-color: #e57373;
		}
		.bdd-node, .bdd-node h6, .bdd-node p, .bdd-node span:not(.label) {
			font-size: .9rem !important;
		}
		td.status-cell {
			width: 75px;
		}
		th {
			font-size: .75rem;
		}
		.table > thead > tr > th:first-child, .table > tbody > tr > td:first-child {
			padding-left: 0;
		}
		.sl-item {
			padding-top: 10px;		
		}
	</style>
	<body>
		<div class="app report-page" id="app">
			<#include 'partials/sidenav.ftl'>
			<!-- content -->
			<div id="content" class="app-content box-shadow-z2 bg pjax-container" role="main" ng-controller="TestController">
				<div class="app-body">
					<!-- ############ PAGE START-->
					<div class="app-body-inner">
						<div class="row-col">
							<div class="col-xs-3 modal fade aside aside-lg" id="subnav" ng-show="isfull">
								<div class="row-col black b-r bg">
									<div class="b-b">
										<div class="navbar no-radius">
											<!-- nabar right -->
											<ul class="nav navbar-nav pull-right m-l">
												<!-- status toggle -->
												<li class="nav-item dropdown">
													<a class="nav-link" data-toggle="dropdown">
													<span class="btn btn-xs white rounded">
														<i class="fa fa-warning"></i>
													</span>
													</a>
													<div class="dropdown-menu text-color pull-right" role="menu">
														<#list statusList as status>
														<a href="/build?id=${report.id}&status=${status?lower_case}" class="dropdown-item">
														<span class="label ${Color.byStatus(status)}">${status?lower_case}</span>
														</a>
														</#list>
														<div class="dropdown-divider"></div>
														<a class="dropdown-item" href="/build?id=${report.id}">
														<i class="fa fa-refresh"></i>
														Reset
														</a>
													</div>
												</li>
												<!-- category toggle -->
												<!-- <li class="nav-item dropdown">
													<a class="nav-link" data-toggle="dropdown">
													<span class="btn btn-xs white rounded">
														<i class="fa fa-tag"></i>
													</span>
													</a>
													<div class="dropdown-menu text-color pull-right" role="menu">
														<#if report.categoryNameList??>
														<#list report.categoryNameList as category>
														<a href="/report?id=${report.id}" class="dropdown-item">
														<span class="label rounded">${category}</span>
														</a>
														</#list>
														</#if>
														<div class="dropdown-divider"></div>
														<a class="dropdown-item" href="/report?id=${report.id}">
														<i class="fa fa-refresh"></i>
														Reset
														</a>
													</div>
												</li> -->
											</ul>
											<!-- link and dropdown -->
											<ul class="nav navbar-nav">
												<li class="nav-item">
													<span class="navbar-item m-r-0 text-md">Tests</span>
												</li>
												<li class="nav-item">
													<a class="nav-link">
													<span class="label warn rounded">
													${testList?size} items
													</span>
													</a>
												</li>
											</ul>
											<!-- / link and dropdown -->
										</div>
									</div>
									<!-- test list -->
									<div class="row-row">
										<div class="row-body scrollable hover">
											<div class="row-inner">
												<!-- left content -->
												<div class="list" data-ui-list="b-r b-2x b-theme">
													<!-- TEST SUMMARY -->
													<#list testList as test>
													<div class="list-item">
														<div class="list-body">
															<div class="pull-right">
																<span class="label ${Color.byStatus(test.status)}">${test.status}</span>
															</div>
															<div class="item-title" ng-click="findTest('${test.id}', false)">
																<a href="#" class="_500">${test.name}</a>
															</div>
															<small class="block text-ellipsis">
															<span class="text-xs">
															<#if (test.duration)??>
															${test.duration?string}
															<#else>
															0
															</#if>
															</span> <span class="text-muted">ms</span>
															</small>
														</div>
													</div>
													</#list>
													<!-- / TEST SUMMARY -->
												</div>
												<!-- / -->
											</div>
										</div>
									</div>
									<!-- / -->
									<!-- footer -->
									<div class="p-a b-t clearfix">
										<div class="btn-group pull-right">
											<!-- <a href="#" class="btn btn-xs white circle"><i class="fa fa-fw fa-angle-left"></i></a>
												<a href="#" class="btn btn-xs white circle"><i class="fa fa-fw fa-angle-right"></i></a> -->
										</div>
										<span class="text-sm text-muted">Total: <strong>${testList?size}</strong></span>
									</div>
									<!-- / -->
								</div>
							</div>
							<div class="col-xs-4 modal fade aside aside-sm" id="list">
								<div class="row-col b-r light lt">
									<div class="b-b">
										<div class="navbar no-radius">
											<a data-toggle="modal" data-target="#subnav" data-ui-modal class="navbar-item pull-left hidden-xl-up hidden-sm-down">
											<span class="btn btn-sm btn-icon blue">
											<i class="fa fa-th"></i>
											</span>
											</a>
											<!-- Current Navbar -->
											<ul class="nav navbar-nav pull-right m-l" ng-if="currentTest">
												<li class="nav-item dropdown">
													<a class="nav-link text-muted" href="#" data-toggle="dropdown">
													<i class="fa fa-ellipsis-h"></i>
													</a>
													<div class="dropdown-menu pull-right text-color" role="menu">
														<a class="dropdown-item" ng-click="findTest(currentTest.id, false)">
														<i class="fa fa-refresh"></i>
														<span >Refresh</span>
														</a>
														<a class="dropdown-item" ng-click="findHistory(currentTest)">
														<i class="fa fa-history"></i>
														<span>History</span>
														</a>
                                                        <a class="dropdown-item" ng-click="showFull()">
                                                            <i class="fa fa-showFull"></i>
                                                            <span>Full</span>
                                                        </a>
														<div class="dropdown-divider"></div>
														<a class="dropdown-item">
														<i class="fa fa-close"></i>
														Close
														</a>
													</div>
												</li>
											</ul>
											<!-- / Current Navbar -->
											<!-- link and dropdown -->
											<ul class="nav navbar-nav">
												<li class="nav-item">
													<span class="navbar-item m-r-0 text-sm">{{currentTest.name}}</span>
												</li>
											</ul>
											<!-- / link and dropdown -->
										</div>
									</div>
									<!-- flex content -->
									<div class="row-row">
										<div class="row-body scrollable hover">
											<div class="row-inner">
												
												<!-- if this is a bdd report -->
												<#if isBDD>
													<div class="p-a" ng-if="currentTest">
														<!-- PARENT -->
														<h4><small class="_600" ng-if="currentTest.bddType">{{currentTest.bddType}}:</small> {{currentTest.name}}</h4>
														<span class="label teal">{{currentTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label brown">{{currentTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label {{getColor(currentTest.status)}}">{{currentTest.status}}</span>
														
														<!-- parent categories -->
														<div ng-if="currentTest.categoryNameList">
															<span class="label rounded warn" style="margin-right:2px;" ng-repeat="category in currentTest.categoryNameList">
																<i class="fa fa-tag"></i> &nbsp;
																{{category}}
															</span>
														</div>
														
														<br/><br/>
														
														<!-- parent nodes -->
														<div class="bdd-node" ng-if="currentTest.nodes.length">
															<!-- node1 -->
															<div class="p-a box light border-box" ng-repeat="node1 in currentTest.nodes">
																<p ng-if="node1.categorized">
																	<span class="label rounded warn" ng-repeat="category in node1.categoryNameList"><i class="fa fa-tag"></i> &nbsp; {{category}}</span>
																</p>
															
																<h6><small class="_600" ng-if="node1.bddType">{{node1.bddType}}:</small> {{node1.name}}</h6>
																
																<!-- node1 logs -->
																<div class="list-group m-b log" ng-if="node1.logs" ng-repeat="log in node1.logs">
																	<p class="list-group-item b-l-{{getBootstrapColor(log.status)}}" 
																		ng-bind-html="trust(log.details)">
																	</p>
																	<p class="list-group-item b-l-{{getBootstrapColor(log.status)}}" ng-if="log.media" ng-repeat="m in log.media"> 
																		<a href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																			<span class="label info">img</span>
																		</a>
																	</p>
																</div>
																
																<!-- node1 media -->
																<div class="row">
																	<div class="col-sm-4 media" ng-if="node1.media" ng-repeat="m in node1.media">
																		<div ng-if="m.base64String" class="box p-a">
																			<a href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																				<img class="img-responsive" src="data:image/png;base64,{{m.base64String}}">
																			</a>
																		</div>
																	</div>
																</div>
																
																<!-- node1 nodes -->
																<div ng-if="node1.nodes.length">
																	<!-- nodes -->
																	<div ng-repeat="node2 in node1.nodes" ng-class="node2.status" class="node p-a">
																		<h6><small class="_600" ng-if="node2.bddType">{{node2.bddType}}:</small> {{node2.name}}</h6>
																		
																		<!-- node2 logs -->
																		<div class="log" ng-if="node2.logs" ng-repeat="log in node2.logs">
																			<span ng-bind-html="trust(log.details)"></span>
																			<a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																				<span class="label info">img</span>
																			</a>
																		</div>

																		<!-- node2 media -->
																		<a ng-if="node2.media && !m.log" ng-repeat="m in node2.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																			<span class="label info">img</span>
																		</a>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</#if>
											
												<#if !isBDD>
													<div class="p-a" ng-if="currentTest">
														<!-- PARENT -->
														<h4><small class="_600">{{currentTest.name}}</small></h4>
														<span class="label teal">{{currentTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label brown">{{currentTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label {{getColor(currentTest.status)}}">{{currentTest.status}}</span>
														
														<!-- parent categories -->
														<div ng-if="currentTest.categoryNameList">
															<span class="label rounded warn" style="margin-right:2px;" ng-repeat="category in currentTest.categoryNameList">
																<i class="fa fa-tag"></i> &nbsp;
																{{category}}
															</span>
														</div>
														
														<br/>
														<br/>
														
														<div class="streamline" ng-if="currentTest.logs">
													        <div ng-repeat="log in currentTest.logs" class="sl-item b-{{getBootstrapColor(log.status)}}">
													          <div class="sl-icon">
													            <i class="fa fa-{{getFont(log.status)}}"></i>
													          </div>
													          <div class="sl-content">
													            <div class="sl-date text-muted">{{getTime(log.timestamp)}}</div>
													            <div ng-bind-html="trust(log.details)"></div>
													            <a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																	<span class="label">img</span>
																</a>
																<div>&nbsp;</div>
													          </div>
													        </div>
													    </div>
																		
														<!-- parent media -->
														<a ng-if="currentTest.media" ng-repeat="m in currentTest.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
															<span class="label">img</span>
														</a>
														
														<!-- parent nodes -->
														<div class="" ng-if="currentTest.nodes.length">
															<!-- node1 -->
															<div class="p-a box border-box light" ng-repeat="node1 in currentTest.nodes">
																<span class="label {{getColor(node1.status)}} pull-right">{{node1.status}}</span>
																<h6 class="_600">{{node1.name}}</h6>
																
																<!-- node1 categories -->
																<div style="margin-top:-10px;margin-bottom:10px;" ng-if="node1.categoryNameList">
																	<span class="label rounded warn" ng-repeat="category in node1.categoryNameList">
																		<i class="fa fa-tag"></i> &nbsp;
																		{{category}}
																	</span>
																</div>
																
																<!-- node1 logs -->
																<div class="streamline" ng-if="node1.logs">
															        <div ng-repeat="log in node1.logs" class="sl-item b-{{getBootstrapColor(log.status)}}">
															          <div class="sl-icon">
															            <i class="fa fa-{{getFont(log.status)}}"></i>
															          </div>
															          <div class="sl-content">
															            <div class="sl-date text-muted">{{getTime(log.timestamp)}}</div>
															            <div ng-bind-html="trust(log.details)"></div>
															            <a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																			<span class="label">img</span>
																		</a>
															          </div>
															        </div>
															    </div>
																
																<!-- node1 media -->
																<div ng-if="node1.media">
																	<a ng-repeat="m in node1.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																		<span class="label">img</span>
																	</a>
																</div>
																
																<!-- node1 nodes -->
																<div class="p-a" ng-if="node1.nodes.length">
																	<!-- nodes -->
																	<div ng-repeat="node2 in node1.nodes">
																		<span class="label {{getColor(node2.status)}} pull-right">{{node2.status}}</span>
																		<h6 class="_600">{{node2.name}}</h6>
																		
																		<!-- node2 categories -->
																		<div ng-if="node2.categoryNameList">
																			<span class="label rounded warn" ng-repeat="category in node2.categoryNameList">
																				<i class="fa fa-tag"></i> &nbsp;
																				{{category}}
																			</span>
																		</div>
																		
																		<!-- node2 logs -->
																		<div class="streamline" ng-if="node2.logs">
																	        <div ng-repeat="log in node2.logs" class="sl-item b-{{getBootstrapColor(log.status)}}">
																	          <div class="sl-icon">
																	            <i class="fa fa-{{getFont(log.status)}}"></i>
																	          </div>
																	          <div class="sl-content">
																	            <div class="sl-date text-muted">{{getTime(log.timestamp)}}</div>
																	            <div ng-bind-html="trust(log.details)"></div>
																	            <a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																					<span class="label">img</span>
																				</a>
																				<div>&nbsp;</div>
																	          </div>
																	        </div>
																	    </div>
																		
																		<!-- node2 media -->
																		<div ng-if="node2.media">
																			<a ng-repeat="m in node1.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																				<span class="label">img</span>
																			</a>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</#if>
											</div>
										</div>
									</div>
									<!-- / -->
									<!-- footer -->
									<!-- / -->
								</div>
							</div>
							<div class="col-xs-4 id="detail" ng-show="isfull">
								<div class="row-col white b-r">
									<div class="b-b">
										<div class="navbar no-radius">
											<!-- nabar right -->
											<ul class="nav navbar-nav pull-right m-l">
												<li class="nav-item dropdown" ng-if="historicalList.length">
													<a class="nav-link">
													<span class="label warn rounded">
													{{historicalList.length}} items
													</span>
													</a>
												</li>
											</ul>
											<!-- / navbar right -->
											<a data-toggle="modal" data-target="#subnav" data-ui-modal class="navbar-item pull-left hidden-md-up">
											<span class="btn btn-sm btn-icon blue">
											<i class="fa fa-th"></i>
											</span>
											</a>
											<a data-toggle="modal" data-target="#list" data-ui-modal class="navbar-item pull-left hidden-md-up">
											<span class="btn btn-sm btn-icon btn-default">
											<i class="fa fa-list"></i>
											</span>
											</a>
											<span class="navbar-item text-sm text-ellipsis">{{historicalTest.name}}</span>
										</div>
									</div>
									<!-- flex content -->
									<div class="row-row">
										<div class="row-body scrollable hover">
											<div class="row-inner">
												
												<!-- if this is a bdd report -->
												<#if isBDD>
													<div class="p-a" ng-if="historicalTest">
														<!-- PARENT -->
														<h4><small class="_600" ng-if="historicalTest.bddType">{{historicalTest.bddType}}:</small> {{historicalTest.name}}</h4>
														<span class="label teal">{{historicalTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label brown">{{historicalTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label {{getColor(historicalTest.status)}}">{{historicalTest.status}}</span>
														
														<br/><br/>
														
														<!-- parent nodes -->
														<div class="bdd-node" ng-if="historicalTest.nodes.length">
															<!-- nodeH1 -->
															<div class="p-a box border-box" ng-repeat="nodeH1 in historicalTest.nodes">
																<p ng-if="nodeH1.categorized">
																	<span class="label blue-grey" ng-repeat="category in nodeH1.categoryNameList"><i class="fa fa-tag"></i> &nbsp; {{category}}</span>
																</p>
															
																<h6><small class="_600" ng-if="nodeH1.bddType">{{nodeH1.bddType}}:</small> {{nodeH1.name}}</h6>
																
																<!-- nodeH1 logs -->
																<div class="list-group m-b log" ng-if="nodeH1.logs" ng-repeat="log in nodeH1.logs">
																	<p class="list-group-item b-l-{{getBootstrapColor(log.status)}}" 
																		ng-bind-html="trust(log.details)">
																	</p>
																	<p class="list-group-item b-l-{{getBootstrapColor(log.status)}}" ng-if="log.media" ng-repeat="m in log.media"> 
																		<a href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																			<span class="label info">img</span>
																		</a>
																	</p>
																</div>
																
																<!-- nodeH1 media -->
																<div class="row">
																	<div class="col-sm-4 media" ng-if="nodeH1.media" ng-repeat="m in nodeH1.media">
																		<div ng-if="m.base64String" class="box p-a">
																			<a href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																				<img class="img-responsive" src="data:image/png;base64,{{m.base64String}}">
																			</a>
																		</div>
																	</div>
																</div>
																
																<!-- nodeH1 nodes -->
																<div ng-if="nodeH1.nodes.length">
																	<!-- nodes -->
																	<div ng-repeat="nodeH2 in nodeH1.nodes" ng-class="nodeH2.status" class="node p-a">
																		<h6><small class="_600" ng-if="nodeH2.bddType">{{nodeH2.bddType}}:</small> {{nodeH2.name}}</h6>
																		
																		<!-- nodeH2 logs -->
																		<div class="log" ng-if="nodeH2.logs" ng-repeat="log in nodeH2.logs">
																			<span ng-bind-html="trust(log.details)"></span>
																			<a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																				<span class="label">
																					<i class="fa fa-image"></i>
																				</span>
																			</a>
																		</div>

																		<!-- nodeH2 media -->
																		<div ng-if="nodeH2.media && !m.log" ng-repeat="m in nodeH2.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																			<span class="label">
																				<i class="fa fa-image"></i>																		
																			</span>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</#if>
												
												<#if !isBDD>
													<div class="p-a" ng-if="historicalTest">
														<!-- PARENT -->
														<h4><small class="_600">{{historicalTest.name}}</small></h4>
														<span class="label teal">{{historicalTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label brown">{{historicalTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
														<span class="label {{getColor(historicalTest.status)}}">{{historicalTest.status}}</span>
														
														<br/><br/>
														
														<div class="streamline" ng-if="historicalTest.logs">
													        <div ng-repeat="log in historicalTest.logs" class="sl-item b-{{getBootstrapColor(log.status)}}">
													          <div class="sl-icon">
													            <i class="fa fa-{{getFont(log.status)}}"></i>
													          </div>
													          <div class="sl-content">
													            <div class="sl-date text-muted">{{getTime(log.timestamp)}}</div>
													            <div ng-bind-html="trust(log.details)"></div>
													            <a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																	<span class="label">img</span>
																</a>
																<div>&nbsp;</div>
													          </div>
													        </div>
													    </div>
																		
														<!-- parent media -->
														<a ng-if="historicalTest.media" ng-repeat="m in historicalTest.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
															<span class="label">img</span>
														</a>
														
														<!-- parent nodes -->
														<div class="" ng-if="historicalTest.nodes.length">
															<!-- nodeH1 -->
															<div class="p-a box border-box" ng-repeat="nodeH1 in historicalTest.nodes">
																<span class="label {{getColor(nodeH1.status)}} pull-right">{{nodeH1.status}}</span>
																<h6 class="_600">{{nodeH1.name}}</h6>
																
																<!-- nodeH1 logs -->
																<div class="streamline" ng-if="nodeH1.logs">
															        <div ng-repeat="log in nodeH1.logs" class="sl-item b-{{getBootstrapColor(log.status)}}">
															          <div class="sl-icon">
															            <i class="fa fa-{{getFont(log.status)}}"></i>
															          </div>
															          <div class="sl-content">
															            <div class="sl-date text-muted">{{getTime(log.timestamp)}}</div>
															            <div ng-bind-html="trust(log.details)"></div>
															            <a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																			<span class="label">img</span>
																		</a>
															          </div>
															        </div>
															    </div>
																
																<!-- nodeH1 media -->
																<span class="label" ng-if="nodeH1.media" ng-repeat="m in nodeH1.media" style="margin-right: 5px;">
																	<i class="fa fa-image"></i>
																	<a ng-if="m.base64String" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image"></a>
																</span>
																
																<!-- nodeH1 nodes -->
																<div class="p-a" ng-if="nodeH1.nodes.length">
																	<!-- nodes -->
																	<div ng-repeat="nodeH2 in nodeH1.nodes">
																		<span class="label {{getColor(nodeH2.status)}} pull-right">{{nodeH2.status}}</span>
																		<h6 class="_600">{{nodeH2.name}}</h6>
																		
																		<!-- nodeH2 logs -->
																		<div class="streamline" ng-if="nodeH2.logs">
																	        <div ng-repeat="log in nodeH2.logs" class="sl-item b-{{getBootstrapColor(log.status)}}">
																	          <div class="sl-icon">
																	            <i class="fa fa-{{getFont(log.status)}}"></i>
																	          </div>
																	          <div class="sl-content">
																	            <div class="sl-date text-muted">{{getTime(log.timestamp)}}</div>
																	            <div ng-bind-html="trust(log.details)"></div>
																	            <a ng-if="log.media" ng-repeat="m in log.media" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image">
																					<span class="label">img</span>
																				</a>
																				<div>&nbsp;</div>
																	          </div>
																	        </div>
																	    </div>
																		
																		<!-- nodeH2 media -->
																		<span class="label" ng-if="nodeH2.media" ng-repeat="m in nodeH2.media" style="margin-right: 5px;">
																			<i class="fa fa-image"></i>
																			<a ng-if="m.base64String" href="data:image/png;base64,{{m.base64String}}" data-featherlight="image"></a>
																		</span>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</#if>

												<div class="p-a" ng-if="historicalList">
													<div class="box-divider"></div>
													<br/>
													<table class="table table-striped b-t">
														<thead>
															<tr>
																<th>Name</th>
																<th>Date</th>
																<th>Status</th>
															</tr>
														</thead>
														<tbody>
															<tr ng-repeat="history in historicalList">
																<td><a href="#" ng-click="findTest(history.id, true)">{{history.name}}</a></td>
																<td>{{history.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</td>
																<td><span class="label {{getColor(history.status)}}">{{history.status}}</span></td>
															</tr>
														</tbody>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- ############ PAGE END-->
				</div>
			</div>
			<!-- / -->
			<#include 'partials/switcher.ftl'>
			<!-- ############ LAYOUT END-->
		</div>
		<#include 'partials/scripts.ftl'>
		<#include 'partials/angular.ftl'>
	</body>
</html>