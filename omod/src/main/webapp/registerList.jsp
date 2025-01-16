<%@ include file="/WEB-INF/template/include.jsp"%>

<openmrs:require privilege="Manage PTME" otherwise="/login.htm" redirect="/module/ptme/registerList.form" />

<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<%@ include file="template/registerHeader.jsp"%>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
            $("#list-register-table").dataTable({
                "pageLength": 20,
                "order": [[1, "desc"]],
                "language": {
                    "zeroRecords": "Aucun enregistrement ce jour",
                    //"emptyTable": "Aucune donn&eacute;e",
                    paginate: {
                        previous: 'Pr&eacute;c&eacute;dent',
                        next:     'Suivant'
                    },
                    "info":"Affichage de _START_ a _END_ sur _TOTAL_ ",
                    "search": "Filtrer les consultations"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]
            });

            $("#hivCareNumber").change(function (e) {
                var num = $(this).val();
                if (num !== "" || num !== undefined || num !== null) {
                    if (num === '${consultationForm.hivCareNumber}') {
                        $("#familyName").prop('enable', true);
                        $("#givenName").prop('enable', true);
                        $("#age").prop('enable', true);
                    } else {
                        $("#familyName").prop('enable', false);
                        $("#givenName").prop('enable', false);
                        $("#age").prop('enable', false);
                    }
                }

            })
        });
    }
</script>

<spring:message code="ptme.result.positive" var="resultPositive" />
<spring:message code="ptme.result.negative" var="resultNegative" />

<c:if test="${ mode == 'list' }" >

    <div class="box">
        <h3><b>Choix de la consultation</b></h3>
        <div class="line"></div>
        <form:form  modelAttribute="openRegisterForm" method="get" action="" id="form">
            <form:hidden path="mode" />
            <table cellpadding="5" cellspacing="0">
                <tr>
                    <td><spring:message code="ptme.pregnantNumber" /> : </td>
                    <td><form:input path="pregnantNumber" cssClass=""/></td>
                    <td>
                        <form:radiobutton path="register" value="Prenatal" label="Prenatal" />
                        <form:radiobutton path="register" value="Birth" label="Accouchement" />
                        <form:radiobutton path="register" value="Postnatal" label="Postnatal" />
                    </td>
                    <td><input type="submit" value="Saisir la consultation"></td>
                </tr>
            </table>
        </form:form>
    </div>

    <div class="boxHeader"></div>

    <div class="box">
        <h3>
            <b>Liste des Consultations saisies ce jour</b>
        </h3>
        <div class="line"></div>
        <table style="border-collapse: collapse; border: 1px solid #1aac9b" cellspacing="0" cellpadding="5" id="list-register-table" width="100%">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th>Type de registre</th>
                <th>Date de consultation</th>
                <th><spring:message code="ptme.pregnantNumber" /></th>
                <th>Age </th>
                <th><spring:message code="ptme.status.reception" /></th>
                <th><spring:message code="ptme.test.proposal" /></th>
                <th><spring:message code="ptme.test.result" /></th>
                <th><spring:message code="ptme.result.announcement" /></th>
                <th><spring:message code="ptme.arv.discount" /></th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="consult" items="${ listConsultation }">
                <tr>
                    <td>${ consult.registerType }</td>
                    <td><fmt:formatDate type="date" value="${ consult.consultationDate }" pattern="dd/MM/yyyy" /></td>
                    <td>${ consult.pregnantNumber }</td>
                    <td>${ consult.age } ans</td>
                    <td align="center">${ (consult.hivStatusAtReception == 0) ? 'N&#233;gatif': (consult.hivStatusAtReception == 1 ? resultPositive: 'Inconnu')}</td>
                    <td align="center">${ (consult.testProposal == 0) ? 'Non': (consult.testProposal == 1 ? 'Oui' : 'N/A') }</td>
                    <td align="center">${ (consult.testResult == 0) ? 'N&#233;gatif': (consult.testResult == 1 ? resultPositive : 'N/A') }</td>
                    <td align="center">${ (consult.resultAnnouncement == 0) ? 'Non' : (consult.resultAnnouncement == 1 ? 'Oui' : 'N/A')}</td>
                    <td align="center">${ (consult.arvDiscount == 0) ? 'Non' : (consult.arvDiscount == 1 ? 'Oui' : 'N/A') }</td>
                    <td align="center">
                        <table cellpadding="0" cellspacing="0" class="button-table">
                            <tr>
                                <td>
                                    <c:url value="/module/ptme/registerList.form" var="url">
                                        <c:param name="consultationId" value="${consult.consultationId}"/>
                                        <c:param name="register" value="${consult.registerType == 'Accouchement'? 'Birth': (consult.registerType == 'CPoN' ? 'Postnatal' : 'Prenatal')}"/>
                                    </c:url>
                                    <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                                </td>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/registerList.form" var="urlsup">
                                        <c:param name="delId" value="${consult.consultationId}"/>
                                        <c:param name="register" value="${consult.registerType == 'Accouchement'? 'Birth': (consult.registerType == 'CPoN' ? 'Postnatal' : 'Prenatal')}"/>
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

<c:if test="${ mode == 'form' }" >
    <div class="box">
        <b class="">
            <h3>
                <c:if test="${ register == 'Prenatal' }" >
                    <span><spring:message code="ptme.prenatal.register" /></span>
                </c:if>

                <c:if test="${ register == 'Birth' }" >
                    <span><spring:message code="ptme.birth.register" /></span>
                </c:if>

                <c:if test="${ register == 'Postnatal' }" >
                    <span><spring:message code="ptme.postnatal.register" /></span>
                </c:if>
            </h3>
        </b>
        <div class="line"></div>
        <c:set var = "disabled" value = "${ consultationForm.patientId != null ? false : false }"/>
        <form:form modelAttribute="consultationForm" method="post" action="${pageContext.request.contextPath}/module/ptme/registerList.form?register=${register}" id="form">
            <form:hidden path="consultationId"/>
            <form:hidden path="pregnantPatientId"/>
            <form:hidden path="patientId"/>
            <form:hidden path="hivServiceId"/>
            <table cellpadding="5" cellspacing="0">
                <tr>
                    <td class="boldText" colspan="2">
                        Date de consultation <b class="required">*</b> :
                        <form:input path="consultationDate" cssClass="datepickerPtme" />
                        <form:errors cssClass="error" path="consultationDate"/>
                    </td>
                </tr>
                <tr>
                    <td class="">
                        <b>Information Patient</b>
                        <div class="line"></div>
                    </td>
                    <td class="">
                        <b>Service VIH et autres</b>
                        <div class="line"></div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <table cellpadding="5" cellspacing="0">

                            <tr>
                                <td class="boldText"><spring:message code="ptme.pregnantNumber" /> <b class="required">*</b> :</td>
                                <td><form:input path="pregnantNumber" cssClass="" /></td>
                                <td><form:errors cssClass="error" path="pregnantNumber"/> </td>
                            </tr>
                            <tr>
                                <td class="boldText"><spring:message code="ptme.familyName" /></td>
                                <td><form:input path="familyName" cssClass="" disabled="${disabled}" /></td>
                                <td><form:errors cssClass="error" path="familyName"/> </td>
                            </tr>
                            <tr>
                                <td class="boldText"><spring:message code="ptme.givenName" /></td>
                                <td><form:input path="givenName" cssClass="" disabled="${disabled}" /></td>
                                <td><form:errors cssClass="error" path="givenName"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Age <b class="required">*</b> :</td>
                                <td><form:input path="age" cssClass="" size="5" disabled="${disabled}" /> ans </td>
                                <td><form:errors cssClass="error" path="age"/> </td>
                            </tr>
                            <tr>
                                <td class="boldText"><spring:message code="ptme.hivCareNumber" /></td>
                                <td><form:input path="hivCareNumber" cssClass="" /></td>
                                <td><form:errors cssClass="error" path="hivCareNumber"/></td>
                            </tr>
                            <tr>
                                <td class="boldText"><spring:message code="ptme.screeningNumber" /></td>
                                <td><form:input path="screeningNumber" cssClass="" /></td>
                                <td><form:errors cssClass="error" path="screeningNumber"/></td>
                            </tr>
                            <tr>
                                <td class="boldText"><spring:message code="ptme.maritalStatus" /></td>
                                <td>
                                    <spring:message code="ptme.single" var="singleText" />
                                    <form:radiobutton path="maritalStatus" value="1" label="Celibataire" cssClass="" />
                                    <br>
                                    <spring:message code="ptme.married" var="marriedText" />
                                    <form:radiobutton path="maritalStatus" value="2" label="Mariee" cssClass="" />
                                    <br>
                                    <spring:message code="ptme.divorce" var="divorceText" />
                                    <form:radiobutton path="maritalStatus" value="3" label="Divorcee" cssClass="" />
                                    <br>
                                    <spring:message code="ptme.widower" var="widowerText" />
                                    <form:radiobutton path="maritalStatus" value="4" label="${fct:escapeXml(widowerText)}" cssClass="" />
                                    <br>
                                    <spring:message code="ptme.concubinage" var="concubinageText" />
                                    <form:radiobutton path="maritalStatus" value="5" label="${fct:escapeXml(concubinageText)}" cssClass="" />
                                </td>
                                <td><form:errors cssClass="error" path="maritalStatus"/></td>
                            </tr>
                            <c:if test="${ register != 'Prenatal' }" >
                                <tr>
                                    <td class="boldText"><spring:message code="ptme.spousal.screening" /> :</td>
                                    <td>
                                        <form:radiobutton path="spousalScreening" value="0" label="Non" />
                                        <form:radiobutton path="spousalScreening" value="1" label="Oui" />
                                        <form:radiobutton path="spousalScreening" value="2" label="Ne sait pas" />
                                    </td>
                                    <td><form:errors cssClass="error" path="spousalScreening"/></td>
                                </tr>
                                <tr>
                                    <td class="boldText"><spring:message code="ptme.spousal.screening.result" /> :</td>
                                    <td>
                                        <c:if test="">

                                        </c:if>
                                        <form:radiobutton path="spousalScreeningResult" value="0" label="Negatif" />
                                        <form:radiobutton path="spousalScreeningResult" value="1" label="${resultPositive}" />
                                        <form:radiobutton path="spousalScreeningResult" value="2" label="N/A" />
                                    </td>
                                    <td><form:errors cssClass="error" path="spousalScreeningResult"/></td>
                                </tr>
                            </c:if>

                        </table>
                    </td>
                    <td valign="top">
                        <table>
                            <tr>
                                <td>
                                    <table cellpadding="5" cellspacing="0">
                                        <c:if test="${ register == 'Prenatal' }" >
                                            <tr>
                                                <td class="boldText"><spring:message code="ptme.prenatal.rank" /> <b class="required">*</b> : </td>
                                                <td colspan="1">
                                                    <form:radiobutton path="prenatalRank" value="CPN 1" label="CPN 1"/>
                                                    <form:radiobutton path="prenatalRank" value="CPN 2" label="CPN 2" />
                                                    <form:radiobutton path="prenatalRank" value="CPN 3" label="CPN 3" />
                                                    <form:radiobutton path="prenatalRank" value="CPN 4" label="CPN 4" />
                                                    <form:radiobutton path="prenatalRank" value="CPN 5 et plus" label="CPN 5 et plus" />
                                                </td>
                                                <td>
                                                    <form:errors cssClass="error" path="prenatalRank"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="boldText"><spring:message code="ptme.amenorrhea" /> <b class="required">*</b> :</td>
                                                <td><form:input path="weekOfAmenorrhea" cssClass="" size="5" /></td>
                                                <td><form:errors cssClass="error" path="weekOfAmenorrhea"/></td>
                                            </tr>
                                        </c:if>

                                        <tr>
                                            <td class="boldText"><spring:message code="ptme.status.reception" /> <b class="required">*</b> :</td>
                                            <td>
                                                <form:radiobutton path="hivStatusAtReception" value="0" label="Negatif" />
                                                <form:radiobutton path="hivStatusAtReception" value="1" label="Positif" />
                                                <form:radiobutton path="hivStatusAtReception" value="2" label="Inconnu" />
                                            </td>
                                            <td><form:errors cssClass="error" path="hivStatusAtReception"/></td>
                                        </tr>
                                        <tr>
                                            <td class="boldText"><spring:message code="ptme.arv.status" /><b class="required">*</b> :</td>
                                            <td>
                                                <form:radiobutton path="arvStatus" value="0" label="Non" />
                                                <form:radiobutton path="arvStatus" value="1" label="Oui" />
                                                <form:radiobutton path="arvStatus" value="2" label="N/A" />
                                            </td>
                                            <td><form:errors cssClass="error" path="arvStatus"/></td>
                                        </tr>
                                        <tr>
                                            <td class="boldText"><spring:message code="ptme.test.proposal" /> <b class="required">*</b> :</td>
                                            <td>
                                                <form:radiobutton path="testProposal" value="0" label="Non" />
                                                <form:radiobutton path="testProposal" value="1" label="Oui" />
                                                <form:radiobutton path="testProposal" value="2" label="N/A" />
                                            </td>
                                            <td><form:errors cssClass="error" path="testProposal"/></td>
                                        </tr>
                                        <tr>
                                            <td class="boldText"><spring:message code="ptme.test.result" /> <b class="required">*</b> :</td>
                                            <td>
                                                <form:radiobutton path="testResult" value="0" label="Negatif" />
                                                <form:radiobutton path="testResult" value="1" label="Positif" />
                                                <form:radiobutton path="testResult" value="2" label="N/A" />
                                            </td>
                                            <td><form:errors cssClass="error" path="testResult"/></td>
                                        </tr>
                                        <tr>
                                            <td class="boldText"><spring:message code="ptme.result.announcement" /> <b class="required">*</b> :</td>
                                            <td>
                                                <form:radiobutton path="resultAnnouncement" value="0" label="Non" />
                                                <form:radiobutton path="resultAnnouncement" value="1" label="Oui" />
                                                <form:radiobutton path="resultAnnouncement" value="2" label="N/A" />
                                            </td>
                                            <td><form:errors cssClass="error" path="resultAnnouncement"/></td>
                                        </tr>
                                        <tr>
                                            <td class="boldText"><spring:message code="ptme.arv.discount" /> ? <b class="required">*</b> </td>
                                            <td>
                                                <form:radiobutton path="arvDiscount" value="0" label="Non" />
                                                <form:radiobutton path="arvDiscount" value="1" label="Oui" />
                                                <form:radiobutton path="arvDiscount" value="2" label="N/A" />
                                            </td>
                                            <td><form:errors cssClass="error" path="arvDiscount"/></td>
                                        </tr>

                                        <c:if test="${ register == 'Prenatal' }" >
                                            <tr>
                                                <td class="boldText"><spring:message code="ptme.spousal.screening" /> :</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ (pregnantPatient.spousalScreening == 1 || pregnantPatient.spousalScreening == 0)
                                                                   && empty consultationForm.consultationId}">
                                                            <form:radiobutton path="spousalScreening" value="0" label="Non" disabled="true" />
                                                            <form:radiobutton path="spousalScreening" value="1" label="Oui" disabled="true" />
                                                            <form:radiobutton path="spousalScreening" value="2" label="Ne sait pas" disabled="true" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form:radiobutton path="spousalScreening" value="0" label="Non" />
                                                            <form:radiobutton path="spousalScreening" value="1" label="Oui" />
                                                            <form:radiobutton path="spousalScreening" value="2" label="Ne sait pas" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><form:errors cssClass="error" path="spousalScreening"/></td>
                                            </tr>
                                            <tr>
                                                <td class="boldText"><spring:message code="ptme.spousal.screening.result" /> :</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ (pregnantPatient.spousalScreening == 1 || pregnantPatient.spousalScreening == 0)
                                                                   && empty consultationForm.consultationId}">
                                                            <form:radiobutton path="spousalScreeningResult" value="0" label="Negatif" disabled="true" />
                                                            <form:radiobutton path="spousalScreeningResult" value="1" label="Positif" disabled="true" />
                                                            <form:radiobutton path="spousalScreeningResult" value="2" label="N/A" disabled="true" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form:radiobutton path="spousalScreeningResult" value="0" label="Negatif" />
                                                            <form:radiobutton path="spousalScreeningResult" value="1" label="Positif" />
                                                            <form:radiobutton path="spousalScreeningResult" value="2" label="N/A" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><form:errors cssClass="error" path="spousalScreeningResult"/></td>
                                            </tr>
                                            <tr>
                                                <td class="boldText">Date du prochain RDV : </td>
                                                <td><form:input path="appointmentDate" cssClass="datepickerPtme" /></td>
                                                <td><form:errors cssClass="error" path="appointmentDate"/></td>
                                            </tr>
                                        </c:if>

                                        <c:if test="${ register == 'Birth' || register == 'Postnatal' }" >
                                            <c:if test="${ register == 'Birth' }" >
                                                <tr>
                                                    <td class="boldText">Date d'accouchement <b class="required">*</b> : </td>
                                                    <td><form:input path="deliveryDate" cssClass="datepickerPtme" /></td>
                                                    <td><form:errors cssClass="error" path="deliveryDate"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="boldText">Accouchement a domicile <b class="required">*</b> : </td>
                                                    <td>
                                                        <form:radiobutton path="homeBirth" value="false" label="Non" />
                                                        <form:radiobutton path="homeBirth" value="true" label="Oui" />
                                                    </td>
                                                    <td><form:errors cssClass="error" path="homeBirth"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="boldText">Etat de l'enfant &agrave; la naissance : </td>
                                                    <td>
                                                        <form:radiobutton path="childState"  value="1" label="Vivant" /> &nbsp;&nbsp;
                                                        Mort n&eacute; :
                                                        <form:radiobutton path="childState"  value="2" label="Frais" />
                                                        <form:radiobutton path="childState"  value="3" label="Macere" />
                                                    </td>
                                                    <td><form:errors cssClass="error" path="childState"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="boldText">Terme : </td>
                                                    <td>
                                                        <form:radiobutton path="pregnancyIssue" value="1" label="A terme" />
                                                        <form:radiobutton path="pregnancyIssue" value="2" label="Premature" />
                                                        <form:radiobutton path="pregnancyIssue" value="3" label="Post-terme" />
                                                    </td>
                                                    <td><form:errors cssClass="error" path="pregnancyIssue"/></td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <td class="boldText"><spring:message code="ptme.child.arv.prophylaxis" /> ?</td>
                                                <td>
                                                    <form:radiobutton path="childArvProphylaxis" value="0" label="Non" />
                                                    <form:radiobutton path="childArvProphylaxis" value="1" label="Oui" />
                                                    <form:radiobutton path="childArvProphylaxis" value="2" label="N/A" />
                                                </td>
                                                <td><form:errors cssClass="error" path="childArvProphylaxis"/></td>
                                            </tr>

                                        </c:if>

                                        <c:if test="${ register == 'Postnatal' }" >

                                        </c:if>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <c:if test="${ empty consultationForm.consultationId }">
                            <button type="submit" name="action">
                                Enregistrer
                            </button>
                        </c:if>
                        <c:if test="${ not empty consultationForm.consultationId }">
                            <button type="submit" name="action">
                                Modifier
                            </button>
                        </c:if>
                        <button type="button" class="" onclick="document.location.href='${pageContext.request.contextPath}/module/ptme/registerList.form'" >Annuler</button>
                        <%--<button type="button" class="" onclick="" >Supprimer</button>--%>
                    </td>
                </tr>
            </table>

        </form:form>
    </div>
</c:if>

<%@ include file="/WEB-INF/template/footer.jsp"%>