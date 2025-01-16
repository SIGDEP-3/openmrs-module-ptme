<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="Manage PTME Reports" otherwise="/login.htm" redirect="/module/ptme/manageReport.form" />
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<%@ include file="template/reportHeader.jsp"%>

<style type="text/css">
    #selectedDataSetList, #availableDataSetList {
        height: 200px;
        width: 550px;
    }
</style>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
            $("#list-report").dataTable({
//                dom: 'B<"clear">lfrtip',
//                buttons: {
//                    name: 'primary',
//                    buttons: [ 'copy', 'csv', 'excel' ]
//                },
                "pageLength": 20,
                "order": [[0, "asc"]],
                "language": {
                    "zeroRecords": "Aucun rapport &agrave; afficher",
                    paginate: {
                        previous: 'Pr&eacute;c&eacute;dent',
                        next:     'Suivant'
                    },
                    "info":"Affichage de _START_ &agrave _END_ sur _TOTAL_ ",
                    "search": "Filtrer les dataset"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]
            });
            $("a#forward").button();
            $("a#backward").button();

            sortElement("selectedDataSetList");
            sortElement("availableDataSetList");

            $("#form").submit(function (e) {
                //e.preventDefault();
                var select = document.getElementById("selectedDataSetList");
                for (var i = 0; i < select.options.length; i++) {
                    select.options[i].selected="selected";
                }
                return true;
            });

        });

        function moveForward() {
            var forwardVariable = '';
            $("#availableDataSetList :selected").each(function () {
                forwardVariable += '<option value="'+$(this).val()+'" selected="selected">'+$(this).html()+'</option>';
                $(this).remove();
            });

            $("#selectedDataSetList").append(forwardVariable);

            sortElement("selectedDataSetList");
        }

        function moveBackward()
        {
            var backwardVariable='';
            //taking the selected items of list 2 and concatenating to a variable named backward_variable.
            $("#selectedDataSetList :selected").each(function(){
                backwardVariable+="<option value='"+$(this).val()+"'>"+$(this).html()+"</option>";
                $(this).remove();
            });

            $("#selectedDataSetList").each(function(){
                $(this).attr("selected", "selected");
            });

            //Now appending the selected firs list's element to the list 1.
            $("#availableDataSetList").append(backwardVariable);


            //Sorting the list 2 so that it shows the list alphabetically
            sortElement("availableDataSetList");

        }

        function sortElement(id)
        {
            var selectElement = $('#'+id);
            var optionsElement = selectElement.children('option').get();
            optionsElement.sort(function(a, b) {
                var compA = $(a).text().toUpperCase();
                var compB = $(b).text().toUpperCase();
                return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
            });
            $.each(optionsElement, function(index, items) { selectElement.append(items); });

        }

        $("textarea").autoGrow();
    }
</script>

<c:if test="${mode == 'list' || empty(mode)}">
    <div class="box">
        <h3><b>Rapports</b></h3>

        <div class="line"></div>
        <form:form action="" modelAttribute="getReportFromFrom" id="form" method="get" >
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td><input type="submit" value="Nouveau" name="add"></td>
                </tr>
            </table>
        </form:form>
    </div>
    <div class="boxHeader"></div>
    <div class="box">
        <h3>Liste des Rapports</h3>
        <div class="line"></div>
        <table width="100%" style="border: solid #1aac9b 1px" cellpadding="0" cellspacing="0" id="list-report">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th>Nom</th>
                <th>Description</th>
                <th>Cr&eacute;&eacute; par</th>
                <th>Cr&eacute;&eacute; le</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="report" items="${ reports }">
                <tr>
                    <td>${report.reportLabel}</td>
                    <td>${report.description}</td>
                    <td>
                        <c:forEach var="name" items="${ report.creator.person.names }">
                            <c:if test="${ name.preferred }">
                                ${name.familyName} ${name.givenName}
                            </c:if>
                        </c:forEach>
                    </td>
                    <td><fmt:formatDate type="date" value="${report.dateCreated}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                    <td width="30">
                        <table cellpadding="0" cellspacing="0" class="button-table">
                            <tr>
                                <td>
                                    <c:url value="/module/ptme/reportManage.form" var="url">
                                        <c:param name="reportId" value="${report.reportId}"/>
                                    </c:url>
                                    <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                                </td>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/reportManage.form" var="urlsup">
                                        <c:param name="delId" value="${report.reportId}"/>
                                    </c:url>
                                    <a href="${ urlsup }" onclick="return confirm('Voulez-vous vraiment supprimer la ligne ?');">
                                        <img src="/openmrs/images/trash.gif" alt="Supprimer">
                                    </a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>

<c:if test="${mode == 'form'}">
    <div class="box">
        <h3><b>Saisie des rapports</b></h3>
        <div class="line"></div>
        <form:form action="" modelAttribute="reportForm" id="form" method="post">
            <form:hidden path="reportId"/>
            <table cellspacing="0" cellpadding="5" align="">
                <tr>
                    <td>
                        <table cellpadding="5" cellspacing="0" width="100%">
                            <tr>
                                <td class="boldText">Nom <b class="required">*</b> : </td>
                                    <td><form:input path="label"  size="80" cssClass=""/></td>
                                <td><form:errors cssClass="error" path="label"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Description  : </td>
                                <td><form:textarea path="description" rows="5" cssClass="textarea-c" /></td>
                                <td><form:errors cssClass="error" path="description"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Template : </td>
                                <td><form:select path="templateId"  cssClass="selection">
                                    <<option value="">-- S&eacute;lectionner --</option>
                                    <c:forEach  items="${templateList}" var="templateItem">
                                        <option value="${templateItem.templateId}"
                                                <c:if test="${templateItem.templateId == reportForm.templateId}">selected="selected"</c:if> >
                                                ${templateItem.name}
                                        </option>
                                    </c:forEach>
                                </form:select></td>
                                <td><form:errors cssClass="error" path="templateId"/></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="boldText">Ajouter les ensembles de donn&eacute;es <b class="required">*</b> :</td>
                                <td><form:errors cssClass="error" path="selectedDataSetList"/></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table>
                                        <tr>
                                            <td>Liste des Ensembles de donn&eacute;es disponibles</td>
                                            <td></td>
                                            <td>Liste des Ensembles de donn&eacute;es s&eacute;lection&eacute;s</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <form:select path="availableDataSetList"  multiple="true" cssClass="">
                                                    <c:forEach  items="${availableDataSetList}" var="availableDataSetItem">
                                                        <option value="${availableDataSetItem.datasetId}">${availableDataSetItem.name}</option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                            <td>
                                                <a id="forward" onclick="moveForward()" style="font-size: 20px">&DoubleLongRightArrow;</a>
                                                <br>
                                                <a id="backward" onclick="moveBackward()" style="font-size: 20px">&DoubleLongLeftArrow;</a>
                                            </td>
                                            <td>
                                                <form:select path="selectedDataSetList" multiple="true" cssClass="">
                                                    <c:forEach  items="${selectedDataSets}" var="selectedDataSetItem">
                                                        <option value="${selectedDataSetItem.datasetId}" selected="selected">${selectedDataSetItem.name}</option>
                                                    </c:forEach>
                                                </form:select>
                                            </td>
                                        </tr>
                                    </table>

                                </td>

                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <div class="line"></div>
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td>
                        <c:if test="${ empty reportForm.reportId }">
                            <input type="submit" value="Enregistrer" name="action"/>
                        </c:if>
                        <c:if test="${ not empty reportForm.reportId }">
                            <input type="submit" value="Modifier" name="action"/>
                        </c:if>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</c:if>

<%@ include file="template/localFooter.jsp"%>