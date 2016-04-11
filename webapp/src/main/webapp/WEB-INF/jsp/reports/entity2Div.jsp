<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script src="/dspResources/js/reports/entity2Div.js"></script>

<div class="col-sm-12" id="entity2DivId">
	<div class="widget-box">
		<div class="widget-header">
			<h4 class="widget-title">${orgHierarchyList[1].name}</h4>
			<div class="widget-toolbar">
				<a href="#" data-action="collapse">
				<i class="ace-icon fa fa-chevron-up"></i>
				</a>
			</div>
		</div>
		<div class="widget-body">
			<div class="widget-main">
				
				<c:if test="${fn:length(entityList) < 1}">
					<div id="entity2SelectDiv">
						There are no data fitting the above criteria.  Please change your selections.
					</div>
				</c:if>
				<c:if test="${fn:length(entityList) >= 1}">
					<div id="entity2SelectDiv">
						<select name="selected2Entities" class="multiselect form-control" id="entity2Ids" multiple="">
							<c:forEach items="${entityList}" var="entity">
								<option value="${entity.id}"<c:if test="${fn:length(entityList) == 1}"> selected</c:if>>${entity.name}</option>
							</c:forEach> 
						</select>
						<div id="errorMsg_entity${tier}" style="display: none; color:#A94442" class="help-block col-xs-12 col-sm-reset inline"></div>
					
					</div>				
					<button class="btn btn-success btn-next showEntity3Div2Button" id="showEntity3Div2Button" data-last="Show ${orgHierarchyList[2].name}" style="display: none;" rel="${orgHierarchyList[1].name}">
						Show ${orgHierarchyList[2].name}
					</button>
					<button class="btn btn-success btn-next changeEntity2Button" id="changeEntity2Button" data-last="Change ${orgHierarchyList[1].name}" style="display: none;">
						Change ${orgHierarchyList[1].name}
					</button>
				</c:if>
			</div>
		</div>
	</div>
</div><!-- /.span -->





