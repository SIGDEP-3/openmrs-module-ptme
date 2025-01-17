/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.ptme.api.db.hibernate;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.Relationship;
import org.openmrs.api.db.hibernate.DbSessionFactory;
import org.openmrs.module.ptme.*;
import org.openmrs.module.ptme.api.db.PreventTransmissionDAO;
import org.openmrs.module.ptme.utils.*;
import org.openmrs.module.ptme.xml.ReportIndicatorValuesXml;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * It is a default implementation of  {@link PreventTransmissionDAO}.
 */
@Repository
public class HibernatePreventTransmissionDAO implements PreventTransmissionDAO {
	protected final Log log = LogFactory.getLog(this.getClass());

	private DbSessionFactory sessionFactory;

	/**
	 * @param sessionFactory the sessionFactory to set
	 */
	public void setSessionFactory(DbSessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	/**
	 * @return the sessionFactory
	 */
	public DbSessionFactory getSessionFactory() {
		return sessionFactory;
	}

	/**
	 * Pregnant Patient DAO
	 * @return
	 */

	@Override
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<PregnantPatient> getAllPregnantPatient() {
		return (List<PregnantPatient>) sessionFactory.getCurrentSession().createCriteria(PregnantPatient.class).list();
	}

	@Override
	@Transactional(readOnly = true)
	public PregnantPatient getPregnantPatientById(Integer id) {
		return (PregnantPatient) sessionFactory.getCurrentSession().get(PregnantPatient.class, id);
	}

	@Override
	@Transactional
	public PregnantPatient savePregnantPatient(PregnantPatient pregnantPatient) {
		sessionFactory.getCurrentSession().saveOrUpdate(pregnantPatient);
		return pregnantPatient;
	}

	@Override
	@Transactional
	public void deletePregnantPatient(PregnantPatient pregnantPatient) {
		sessionFactory.getCurrentSession().delete(pregnantPatient);
	}

	@Override
	@Transactional
	public PregnantPatient voidPregnantPatient(Integer id) {
		PregnantPatient p = (PregnantPatient) sessionFactory.getCurrentSession().get(PregnantPatient.class, id);
		p.setVoided(true);
		sessionFactory.getCurrentSession().update(p);
		return p;
	}

	@SuppressWarnings("unchecked")
	@Override
	@Transactional
	public List<PregnantPatient> getAllPregnantPatientByVoided(Boolean includeVoided) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PregnantPatient.class);
		return (List<PregnantPatient>) (includeVoided ? criteria.list() : criteria.add(Restrictions.eq("voided", includeVoided)).list());
	}

	@Override
	public PregnantPatient getPregnantPatientByPregnantNumber(String pregnantNumber) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PregnantPatient.class);
		return (PregnantPatient) criteria.add(Restrictions.eq("pregnantNumber", pregnantNumber)).uniqueResult();
	}

	@Override
	public PregnantPatient getPregnantPatientByHivCareNumber(String hivCareNumber) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PregnantPatient.class);
		return (PregnantPatient) criteria.add(Restrictions.eq("hivCareNumber", hivCareNumber)).uniqueResult();
	}

	/**
	 * Hiv Service
	 */

	@SuppressWarnings("unchecked")
	@Override
	public List<HivService> getAllHivService() {
		return (List<HivService>) sessionFactory.getCurrentSession().createCriteria(HivService.class).list();
	}

	@Override
	public HivService getHivServiceById(Integer id) {
		return (HivService) sessionFactory.getCurrentSession().get(HivService.class, id);
	}

	@Override
	@Transactional
	public HivService saveHivService(HivService hivService) {
		sessionFactory.getCurrentSession().saveOrUpdate(hivService);
		return hivService;
	}

	@Override
	@Transactional
	public void deleteHivService(HivService hivService) {
		sessionFactory.getCurrentSession().delete(hivService);
	}

//	@Override
//	@Transactional
//	public HivService voidHivService(Integer id) {
//		HivService h = (HivService) sessionFactory.getCurrentSession().get(HivService.class, id);
//		h.setVoided(true);
//		sessionFactory.getCurrentSession().update(h);
//		return h;
//	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HivService> getAllHivServiceByVoided(Boolean voidedIncluded) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(HivService.class);
		return (List<HivService>) (voidedIncluded ? criteria.list() : criteria.add(Restrictions.eq("voided", voidedIncluded)).list());
	}

	/****
	 * Consultations
	 */

	@Override
	@Transactional
	public Birth saveBirthConsultation(Birth birth) {
		sessionFactory.getCurrentSession().saveOrUpdate(birth);
		return birth;
	}

	@Override
	@Transactional
	public Prenatal savePrenatalConsultation(Prenatal prenatal) {
		sessionFactory.getCurrentSession().saveOrUpdate(prenatal);
		return prenatal;
	}

	@Override
	@Transactional
	public Postnatal savePostnatalConsultation(Postnatal postnatal) {
		sessionFactory.getCurrentSession().saveOrUpdate(postnatal);
		return postnatal;
	}

	@Override
	public Consultation getConsultation(Integer id) {
		return (Consultation) sessionFactory.getCurrentSession().get(Consultation.class, id);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Consultation> getAllConsultations() {
		return (List<Consultation>) sessionFactory.getCurrentSession().createCriteria(Consultation.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Consultation> getAllConsultationsByDate(Date currentDate, Boolean voided) {

		String sQuery = "from Consultation as c where c.dateCreated = :dateCreated and c.voided = :voided order by c.consultationId desc";

		Query query = sessionFactory.getCurrentSession().createQuery(sQuery);

		query.setParameter("dateCreated", UsefullFunction.formatDateToyyyyMMdd(currentDate));
		query.setParameter("voided", voided);
		return (List<Consultation>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ConsultationWithType> getConsultationsByDate(Date currentDate, Boolean voided) {
		String sqlQuery =
				"select pr.rank as RegisterType, " +
						"pr.consultation_id as consultationId, " +
						"c1.consultation_date as consultationDate, " +
						"pp1.pregnant_number as pregnantNumber, "+
						"pp1.age as age, "+
						"h1.hiv_status_at_reception as hivStatusAtReception, " +
						"h1.test_proposal as testProposal, " +
						"h1.test_result as testResult, " +
						"h1.result_announcement as resultAnnouncement, " +
						"h1.arv_discount as arvDiscount " +
						"from ptme_prenatal pr, ptme_consultation c1, ptme_hiv_service h1, ptme_pregnant_patient pp1 " +
						"where pr.consultation_id = c1.consultation_id and h1.hiv_service_id = pr.consultation_id  AND " +
						"pp1.pregnant_patient_id = c1.pregnant_patient_id AND c1.voided = :voided AND (DATE(c1.date_created) = :currentDate OR DATE(c1.date_changed) = :currentDate) " +
						"union " +
						"select 'Accouchement' as RegisterType, " +
						"b.consultation_id as consultationId, " +
						"c2.consultation_date as consultationDate, " +
						"pp2.pregnant_number as pregnantNumber, "+
						"pp2.age as age, "+
						"h2.hiv_status_at_reception as hivStatusAtReception, " +
						"h2.test_proposal as testProposal, " +
						"h2.test_result as testResult, " +
						"h2.result_announcement as resultAnnouncement, " +
						"h2.arv_discount as arvDiscount " +
						"from ptme_birth b, ptme_consultation c2, ptme_hiv_service h2, ptme_pregnant_patient pp2 " +
						"where b.consultation_id = c2.consultation_id and h2.hiv_service_id = b.consultation_id AND " +
						"pp2.pregnant_patient_id = c2.pregnant_patient_id AND c2.voided = :voided AND (DATE(c2.date_created) = :currentDate OR DATE(c2.date_changed) = :currentDate) " +
						"union " +
						"select 'CPoN' as RegisterType, " +
						"po.consultation_id as consultationId, " +
						"c3.consultation_date as consultationDate, " +
						"pp3.pregnant_number as pregnantNumber, " +
						"pp3.age as age, "+
						"h3.hiv_status_at_reception as hivStatusAtReception, " +
						"h3.test_proposal as testProposal, " +
						"h3.test_result as testResult, " +
						"h3.result_announcement as resultAnnouncement, " +
						"h3.arv_discount as arvDiscount " +
						"from ptme_postnatal po, ptme_consultation c3, ptme_hiv_service h3, ptme_pregnant_patient pp3 " +
						"where po.consultation_id = c3.consultation_id and h3.hiv_service_id = po.consultation_id AND " +
						"pp3.pregnant_patient_id = c3.pregnant_patient_id AND c3.voided = :voided AND (DATE(c3.date_created) = :currentDate OR DATE(c3.date_changed) = :currentDate) " +
						"ORDER BY consultationId DESC ";

		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("registerType", StandardBasicTypes.STRING)
				.addScalar("consultationId", StandardBasicTypes.INTEGER)
				.addScalar("consultationDate", StandardBasicTypes.DATE)
				.addScalar("pregnantNumber", StandardBasicTypes.STRING)
				.addScalar("age", StandardBasicTypes.INTEGER)
				.addScalar("hivStatusAtReception", StandardBasicTypes.INTEGER)
				.addScalar("testProposal", StandardBasicTypes.INTEGER)
				.addScalar("testResult", StandardBasicTypes.INTEGER)
				.addScalar("resultAnnouncement", StandardBasicTypes.INTEGER)
				.addScalar("arvDiscount", StandardBasicTypes.INTEGER)
				.setParameter("voided", voided)
				.setResultTransformer(new AliasToBeanResultTransformer(ConsultationWithType.class))
				.setParameter("currentDate", UsefullFunction.formatDateToyyyyMMdd(currentDate))
				;

//		query.setParameter("currentDate", UsefullFunction.formatDateToyyyyMMdd(currentDate));
//		query.setParameter("voided", voided);
		return (List<ConsultationWithType>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Consultation> getConsultationsByDate(Date startDate, Date endDate) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Consultation.class);
		return (List<Consultation>) criteria.add(Restrictions.between("consultationDate", startDate, endDate)).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Birth> getAllBirthConsultation() {
		return (List<Birth>) sessionFactory.getCurrentSession().createCriteria(Birth.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Prenatal> getAllPrenatalConsultation() {
		return (List<Prenatal>) sessionFactory.getCurrentSession().createCriteria(Prenatal.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Postnatal> getAllPostnatalConsultation() {
		return (List<Postnatal>) sessionFactory.getCurrentSession().createCriteria(Postnatal.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Birth> getBirthConsultationsByDate(Date sDate, Date eDate) {
		return (List<Birth>) sessionFactory.getCurrentSession()
				.createQuery("FROM Birth b WHERE  b.consultationDate BETWEEN :sDate AND :eDate AND b.voided = false")
				.setParameter("sDate", sDate)
				.setParameter("eDate", eDate).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Prenatal> getPrenatalConsultationsByDate(Date startDate, Date endDate) {

		return (List<Prenatal>) sessionFactory.getCurrentSession()
				.createQuery("FROM Prenatal p WHERE  p.consultationDate BETWEEN :sDate AND :eDate AND p.voided = false")
				.setParameter("sDate", startDate)
				.setParameter("eDate", endDate).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Postnatal> getPostnatalConsultationsByDate(Date sDate, Date eDate) {
		return (List<Postnatal>) sessionFactory.getCurrentSession()
				.createQuery("FROM Postnatal p WHERE  p.consultationDate BETWEEN :sDate AND :eDate AND p.voided = false")
				.setParameter("sDate", sDate)
				.setParameter("eDate", eDate).list();
	}

	@Override
	public Birth getBirthConsultation(Integer id) {
		return (Birth) sessionFactory.getCurrentSession().get(Birth.class, id);
	}

	@Override
	public Prenatal getPrenatalConsultation(Integer id) {
		return (Prenatal) sessionFactory.getCurrentSession().get(Prenatal.class, id);
	}

	@Override
	public Postnatal getPostnatalConsultation(Integer id) {
		return (Postnatal) sessionFactory.getCurrentSession().get(Postnatal.class, id);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Prenatal> getPrenatalConsultationsByPregnantPatientNumber(String pregnantNumber) {
		return (List<Prenatal>) sessionFactory.getCurrentSession().createQuery("FROM Prenatal p WHERE p.pregnantPatient.pregnantNumber = '" + pregnantNumber + "'").list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Postnatal> getPostnatalConsultationsByPregnantPatientNumber(String pregnantNumber) {
		return (List<Postnatal>) sessionFactory.getCurrentSession().createQuery("FROM Postnatal as p WHERE p.pregnantPatient.pregnantNumber = '" + pregnantNumber + "'").list();
	}

	@Override
	public MotherFollowup getCurrentMotherFollowupByPregnantPatient(PregnantPatient pregnantPatient) {
		return (MotherFollowup) sessionFactory.getCurrentSession().createQuery("FROM MotherFollowup as m where m.pregnancyOutcome IS NULL AND m.voided = false AND m.pregnantPatient.pregnantPatientId = " + pregnantPatient.getPregnantPatientId()).uniqueResult();
	}

	@Override
	public MotherFollowup getMotherFollowupById(Integer motherFollowupId) {
		return (MotherFollowup) sessionFactory.getCurrentSession().get(MotherFollowup.class, motherFollowupId);
	}

	@Override
	public MotherFollowupVisit getMotherFollowUpVisitById(Integer id) {
		return (MotherFollowupVisit) sessionFactory.getCurrentSession().get(MotherFollowupVisit.class, id);
	}

	@Override
	@Transactional
	public MotherFollowup saveMotherFollowup(MotherFollowup motherFollowup) {
		sessionFactory.getCurrentSession().saveOrUpdate(motherFollowup);
		return motherFollowup;
	}

	@Transactional
	@Override
	public void removeMotherFollowupVisit(MotherFollowupVisit motherFollowupVisit) {
		sessionFactory.getCurrentSession().delete(motherFollowupVisit);
	}

	@Override
	public void removeMotherFollowup(MotherFollowup motherFollowup) {
		sessionFactory.getCurrentSession().delete(motherFollowup);
	}

	@Transactional
	@Override
	public MotherFollowupVisit saveMotherFollowupVisit(MotherFollowupVisit motherFollowupVisit) {
		sessionFactory.getCurrentSession().saveOrUpdate(motherFollowupVisit);
		return motherFollowupVisit;
	}

	@Override
	public MotherFollowupVisit getPregnantPatientFollowupByDate(Integer pregnantPatientId, Date visitDate) {
		return (MotherFollowupVisit) sessionFactory.getCurrentSession()
				.createQuery("FROM MotherFollowupVisit m WHERE m.motherFollowup.pregnantPatient.pregnantPatientId = :pregnantPatientId AND m.visitDate = :visitDate")
				.setParameter("pregnantPatientId", pregnantPatientId)
				.setParameter("visitDate", UsefullFunction.formatDateToyyyyMMdd(visitDate)).uniqueResult();
	}

	@Override
	public MotherFollowupVisit getEarlierPregnantPatientFollowupVisitForFollowup(Integer motherFollowupId) {
		return (MotherFollowupVisit) sessionFactory.getCurrentSession()
				.createQuery("FROM MotherFollowupVisit m WHERE m.motherFollowup.motherFollowupId = :motherFollowupId ORDER BY m.visitDate desc ")
				.setParameter("motherFollowupId", motherFollowupId).setFirstResult(0).setMaxResults(1).uniqueResult();
	}

	@Override
	public Child getChildByFollowupNumber(String childFollowupNumber) {
		return (Child) sessionFactory.getCurrentSession().createQuery(
				"FROM Child c WHERE c.childFollowupNumber = '" + childFollowupNumber + "'"
		).uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PregnantPatientToFollow> getPregnantPatientFollowupList() {
		String sqlQuery ="SELECT " +
				"ppp.pregnant_patient_id AS PregnantPatientId," +
				"ppp.family_name AS familyName," +
				"ppp.given_name AS givenName," +
				"ppp.pregnant_number As pregnantNumber," +
				"ppp.screening_number as screeningNumber," +
				"ppp.hiv_care_number as hivCareNumber," +
				"ppp.age " +
				"FROM ptme_pregnant_patient ppp LEFT JOIN" +
				"  ptme_mother_followup pmf ON ppp.pregnant_patient_id = pmf.pregnant_patient_id " +
				"WHERE" +
				"  (pmf.mother_followup_id IS NULL OR pmf.pregnancy_outcome IS NULL) AND" +
				"  ppp.patient_id IS NOT NULL AND ppp.voided = 0 ";

		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("PregnantPatientId",StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("pregnantNumber", StandardBasicTypes.STRING)
				.addScalar("hivCareNumber", StandardBasicTypes.STRING)
				.addScalar("screeningNumber", StandardBasicTypes.STRING)
				.addScalar("age",StandardBasicTypes.INTEGER)
				;
		query.setResultTransformer(new AliasToBeanResultTransformer(PregnantPatientToFollow.class));

		/*return (List<PregnantPatient>) sessionFactory.getCurrentSession().createQuery(
				"FROM PregnantPatient p WHERE p.patient IS NOT NULL AND p.voided = false").list();*/

		return (List<PregnantPatientToFollow>) query.list();
	}

	@Override
	public Patient getPatientByIdentifier(String identifier) {
		Patient patient = null;
		PatientIdentifier patientIdentifier = (PatientIdentifier) sessionFactory.getCurrentSession().createQuery("FROM PatientIdentifier p WHERE p.identifier = '"+identifier+"' AND (p.voided = false AND p.patient.voided = false) AND p.preferred = true").uniqueResult();
		if(patientIdentifier != null) {
			patient = patientIdentifier.getPatient();
		}
		return patient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<MotherFollowupCurrentlyOn> getMotherFollowupCurrentlyOnList(Date startDate, String status, Integer pregnancyOutcome, Date endDate) {

		String sqlQuery =
				"SELECT " +
						"  pmf.mother_followup_id as motherFollowupId," +
						"  hiv_care_number as hivCareNumber," +
						"  age, " +
						"  family_name as familyName, " +
						"  given_name as givenName, " +
						"  arv_status_at_registering as arvStatusAtRegistering, " +
						"  visitCount, " +
						"  start_date as startDate," +
						"  end_date as endDate," +
						"  status," +
						"  lastVisitDate," +
						"  pregnancy_outcome as pregnancyOutcome," +
						"  delivery_type as deliveryType," +
						"  pmf.spousal_screening_date as spousalScreeningDate," +
						"  pmf.spousal_screening_result as spousalScreeningResult " +
						"FROM " +
						"  (SELECT *, if(prengnancy_outcome IS NULL, 'Off', 'On') status FROM ptme_mother_followup) pmf, " +
						"  ptme_pregnant_patient ppp, " +
						"  ( SELECT count(*) visitCount, mother_followup_id FROM ptme_mother_followup_visit GROUP BY mother_followup_id) pmfv2, " +
						"  ( SELECT max(visit_date) lastVisitDate, mother_followup_id FROM ptme_mother_followup_visit GROUP BY mother_followup_id) pmfv3 " +
						"WHERE " +
						"  pmf.pregnant_patient_id = ppp.pregnant_patient_id AND " +
						"  pmf.mother_followup_id = pmfv2.mother_followup_id AND " +
						"  pmf.mother_followup_id = pmfv3.mother_followup_id AND " +
						"  pmf.voided = FALSE ";

		if (startDate != null)
			sqlQuery = sqlQuery + " AND pmf.start_date = :startDate";
		if (status != null)
			sqlQuery = sqlQuery + " AND pmf.Status = :status";
		if (endDate != null)
			sqlQuery = sqlQuery + " AND pmf.end_date = :endDate";
		if (pregnancyOutcome != null)
			sqlQuery = sqlQuery + " AND pmf.pregnacy_outcome = :pregnancyOutcome";

		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("motherFollowupId", StandardBasicTypes.INTEGER)
				.addScalar("hivCareNumber", StandardBasicTypes.STRING)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("status", StandardBasicTypes.STRING)
				.addScalar("arvStatusAtRegistering", StandardBasicTypes.INTEGER)
				.addScalar("visitCount", StandardBasicTypes.INTEGER)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE)
				.addScalar("startDate", StandardBasicTypes.DATE)
				.addScalar("endDate", StandardBasicTypes.DATE)
				.addScalar("pregnancyOutcome", StandardBasicTypes.INTEGER)
				.addScalar("deliveryType", StandardBasicTypes.INTEGER)
				.addScalar("spousalScreeningDate", StandardBasicTypes.DATE)
				.addScalar("spousalScreeningResult", StandardBasicTypes.INTEGER);

		if (startDate != null)
			query.setParameter("startDate", startDate);
		if (endDate != null)
			query.setParameter("endDate", endDate);
		if (status != null)
			query.setParameter("status", status);
		if (pregnancyOutcome != null)
			query.setParameter("pregnancyOutcome", pregnancyOutcome);

		query.setResultTransformer(new AliasToBeanResultTransformer(MotherFollowupCurrentlyOn.class));

		return (List<MotherFollowupCurrentlyOn>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Child> getChildList() {
//		return (List<Child>) sessionFactory.getCurrentSession().createQuery(
//				"FROM Child c WHERE (c.childFollowup IS null OR c.childFollowup.followupResult IS null ) and c.voided = false"
//		).list();
		return (List<Child>) sessionFactory.getCurrentSession().createQuery(
				"SELECT c FROM Child c LEFT JOIN c.childFollowup f WHERE (f = null OR f.followupResult = null ) AND c.voided = false"
		).list();
	}

	@Override
	public Child getChildById(Integer childId) {
		// System.out.println(childId + "------------Child dans la requete----------------------");
		return (Child) sessionFactory.getCurrentSession().get(Child.class, childId);
	}

	@Transactional
	@Override
	public Child saveChild(Child child) {
		sessionFactory.getCurrentSession().saveOrUpdate(child);
		return child;
	}

	@Override
	public Child getChildByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Child.class);
		return (Child)  criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@Override
	public void removeChild(Child child) {
		sessionFactory.getCurrentSession().delete(child);
	}

	@Override
	public PregnantPatient getPregnantPatientByUuid(String s) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PregnantPatient.class);
		return (PregnantPatient) criteria.add(Restrictions.eq("uuid", s)).uniqueResult();
	}

	@Override
	public void removePregnantPatient(PregnantPatient pregnantPatient) {
		sessionFactory.getCurrentSession().delete(pregnantPatient);
	}

	@Override
	public ChildFollowup getChildFollowupByUuid(String s) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ChildFollowup.class);
		return (ChildFollowup) criteria.add(Restrictions.eq("uuid", s)).uniqueResult();
	}

	@Override
	public Birth getBirthConsultationByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Birth.class);
		return (Birth) criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@Override
	public Prenatal getPrenatalConsultationByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Prenatal.class);
		return (Prenatal) criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@Override
	public Postnatal getPostnatalConsultationByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Postnatal.class);
		return (Postnatal) criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@Override
	public HivService getHivServiceByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(HivService.class);
		return (HivService) criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@Override
	public ChildFollowupVisit getChildFollowupVisitByUuid(String uuid) {
		return null;
	}

	@Override
	public MotherFollowup getMotherFollowupByUuid(String uuid) {
		return null;
	}

	@Override
	public MotherFollowupVisit getMotherFollowupVisitByUuid(String uuid) {
		return null;
	}

	@Override
	public ChildFollowup getChildFollowupById(Integer childFollowupId) {
		return (ChildFollowup) sessionFactory.getCurrentSession().get(ChildFollowup.class, childFollowupId);
	}

	@Override
	public ChildFollowupVisit getChildFollowupVisitById(Integer childFollowupVisitId) {
		return  (ChildFollowupVisit) sessionFactory.getCurrentSession().get(ChildFollowupVisit.class, childFollowupVisitId);
	}

	@Transactional
	@Override
	public ChildFollowup saveChildFollowup(ChildFollowup childFollowup) {
		sessionFactory.getCurrentSession().saveOrUpdate(childFollowup);
		return childFollowup;
	}

	@Transactional
	@Override
	public ChildFollowupVisit saveChildFollowupVisit(ChildFollowupVisit childFollowupVisit) {
		sessionFactory.getCurrentSession().saveOrUpdate(childFollowupVisit);
		return childFollowupVisit;
	}

	@Override
	public ChildFollowupVisit getChildFollowupVisitByChildAndDate(Integer childId, Date visitDate) {
		return (ChildFollowupVisit) sessionFactory.getCurrentSession().createQuery("FROM " +
				"ChildFollowupVisit c WHERE c.child.childId = :childId AND c.visitDate = :visitDate AND c.voided = false")
				.setParameter("childId", childId)
				.setParameter("visitDate", visitDate).uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ChildFollowupVisit> getChildFollowupVisitByChild(Integer childId) {
		return (List<ChildFollowupVisit>) sessionFactory.getCurrentSession().createQuery("FROM " +
				"ChildFollowupVisit c WHERE c.child.childId = :childId AND c.voided = false ORDER BY c.visitDate desc")
				.setParameter("childId", childId)
				.list();
	}

	@Transactional
	@Override
	public void deleteChildFollowupVisit(ChildFollowupVisit childFollowupVisit) {
		sessionFactory.getCurrentSession().delete(childFollowupVisit);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ChildFollowupTransformer> getChildFollowupList(String status, Date startDate, Date endDate) {
		String sqlQuery =
				"SELECT" +
						"  pc.child_id AS childId," +
						"  pc.child_followup_number AS childFollowupNumber," +
						"  birth_date AS birthDate, " +
						"  family_name AS familyName," +
						"  given_name givenName," +
						"  gender," +
						"  IF(pcr3_result IS NOT NULL, 'PCR 3'," +
						"     IF(pcr2_result IS NOT NULL, 'PCR 2'," +
						"        IF(pcr1_result IS NOT NULL, 'PCR 1', NULL)) ) AS lastPCR," +
						"  IF(pcr3_result IS NOT NULL, pcr3_sampling_date," +
						"     IF(pcr2_result IS NOT NULL, pcr2_sampling_date," +
						"        IF(pcr1_result IS NOT NULL, pcr1_sampling_date, NULL)) ) AS lastPCRDate," +
						"  IF(pcr3_result IS NOT NULL, pcr3_result," +
						"     IF(pcr2_result IS NOT NULL, pcr2_result," +
						"        IF(pcr1_result IS NOT NULL, pcr1_result, NULL)) ) AS lastPCRResult," +
						"  ctx_initiation_date AS ctxInitiationDate," +
						"  inh_initiation_date AS inhInitiationDate," +
						"  status," +
						"  visitCount," +
						"  lastVisitDate," +
						"  followup_result AS  result," +
						"  followup_result_date AS resultDate " +
						"FROM " +
						"  (SELECT *, if(followup_result IS NOT NULL, 'Off', 'On') status FROM ptme_child_followup) pcf," +
						"  ptme_child pc," +
						"  ( SELECT count(*) visitCount, child_id FROM ptme_child_followup_visit GROUP BY child_id) pcfv1," +
						"  ( SELECT max(visit_date) lastVisitDate, child_id FROM ptme_child_followup_visit GROUP BY child_id) pcfv2 " +
						"WHERE" +
						"  pc.child_id = pcf.child_followup_id AND" +
						"  pcfv1.child_id = pc.child_id AND" +
						"  pcfv2.child_id = pc.child_id AND" +
						"  pcf.status = :status AND pcf.voided = false ";

		if (status.equals("Off")) {
			if (startDate != null && endDate != null) {
				sqlQuery = sqlQuery + " AND pcf.followup_result_date BETWEEN :startDate AND :endDate";
			} else if (startDate != null) {
				sqlQuery = sqlQuery + " AND pcf.followup_result_date = :startDate";
			} else if (endDate != null) {
				sqlQuery = sqlQuery + " AND pcf.followup_result_date = :endDate";
			}
		}
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("childId", StandardBasicTypes.INTEGER)
				.addScalar("childFollowupNumber", StandardBasicTypes.STRING)
				.addScalar("birthDate", StandardBasicTypes.DATE)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("gender", StandardBasicTypes.STRING)
				.addScalar("lastPcr", StandardBasicTypes.STRING)
				.addScalar("lastPcrDate", StandardBasicTypes.DATE)
				.addScalar("lastPcrResult", StandardBasicTypes.INTEGER)
				.addScalar("ctxInitiationDate", StandardBasicTypes.DATE)
				.addScalar("inhInitiationDate", StandardBasicTypes.DATE)
				.addScalar("status", StandardBasicTypes.STRING)
				.addScalar("visitCount", StandardBasicTypes.INTEGER)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE)
				.addScalar("result", StandardBasicTypes.INTEGER)
				.addScalar("resultDate", StandardBasicTypes.DATE)
				.setParameter("status", status);

		if (status.equals("Off")) {
			if (startDate != null && endDate != null) {
				query.setParameter("startDate", startDate).setParameter("endDate", endDate);
			} else if (startDate != null) {
				query.setParameter("startDate", startDate);
			} else if (endDate != null) {
				query.setParameter("endDate", endDate);
			}
		}
		query.setResultTransformer(new AliasToBeanResultTransformer(ChildFollowupTransformer.class));

		return (List<ChildFollowupTransformer>) query.list();
	}

	@Transactional
	@Override
	public void deleteChildFollowup(ChildFollowup childFollowup) {
		sessionFactory.getCurrentSession().delete(childFollowup);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<MotherFollowupVisit> getMotherFollowupVisitByPatientAndFollowup(MotherFollowup motherFollowup) {
		return (List<MotherFollowupVisit>) sessionFactory.getCurrentSession().createQuery("FROM " +
				"MotherFollowupVisit m WHERE m.motherFollowup = :motherFollowup " +
				"AND m.voided = false ORDER BY m.visitDate desc")
				.setParameter("motherFollowup", motherFollowup)
				.list();
	}

	@Override
	public Relationship getChildRelationship(Patient mother, Patient patient) {
		return (Relationship) sessionFactory.getCurrentSession().createQuery("FROM " +
				"Relationship r WHERE r.personA = :mother AND personB = :child " +
				"AND r.voided = false")
				.setParameter("mother", mother)
				.setParameter("child", patient).uniqueResult();
	}

	@Override
	public Consultation getPatientConsultationByDate(Integer pregnantPatientId, Date consultationDate) {
		return (Consultation) sessionFactory.getCurrentSession().createQuery("FROM Consultation c " +
				"WHERE c.pregnantPatient.pregnantPatientId = :pregnantPatientId AND " +
				"c.consultationDate = :consultationDate AND c.voided = false")
				.setParameter("consultationDate", consultationDate)
				.setParameter("pregnantPatientId", pregnantPatientId).uniqueResult();
	}

	@Override
	public Integer getNumberOfPrenatalConsultation(String prenatalConsultationRank, Date startDate, Date endDate) {
		String sqlQuery = "SELECT COUNT(*) FROM ptme_prenatal";

		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery);
		return null;
	}

	@Override
	public Integer getNumberOfPrenatalConsultationARV(String prenatalConsultationRank, Date startDate, Date endDate) {
		return null;
	}

	@Override
	public Integer getNumberOfBirthConsultationARV(Date startDate, Date endDate) {
		return null;
	}

	@Override
	public Integer getNumberOfBirthConsultationLocation(Date startDate, Date endDate, String location) {
		return null;
	}

	@Override
	public Integer getNumberOfPostnatalConsultation(Date startDate, Date endDate) {
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<MotherFollowupAppointment> getPregnantPatientsAppointment() {

		String sqlQuery =
				"SELECT" +
						"  pregnant_number AS pregnantNumber," +
						"  hiv_care_number AS hivCareNumber," +
						"  lastVisitDate," +
						"  numberOfVisit," +
						"  AppointmentDate, " +
						"  passed, " +
						"  family_name as familyName," +
						"  given_name as givenName, " +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) contact " +
						"FROM" +
						"  (SELECT * FROM ptme_mother_followup WHERE voided = 0) pmf" +
						"  INNER JOIN (SELECT MAX(visit_date) lastVisitDate, mother_followup_id FROM ptme_mother_followup_visit WHERE voided = 0 GROUP BY mother_followup_id) lpmfv" +
						"    ON pmf.mother_followup_id = lpmfv.mother_followup_id" +
						"  LEFT JOIN (SELECT *," +
						"               ADDDATE(visit_date, INTERVAL 1 MONTH) AppointmentDate," +
						"               IF(ADDDATE(visit_date, INTERVAL 1 MONTH) > NOW(), 0, " +
						"                  IF(ADDDATE(visit_date, INTERVAL 1 MONTH) = DATE(NOW()), 1, 2)) passed FROM ptme_mother_followup_visit WHERE voided = 0) pmfv ON pmf.mother_followup_id = lpmfv.mother_followup_id AND lpmfv.lastVisitDate = pmfv.visit_date" +
						"  LEFT JOIN ptme_pregnant_patient ppp ON pmf.pregnant_patient_id = ppp.pregnant_patient_id" +
						"  LEFT JOIN (SELECT COUNT(mother_followup_visit_id) numberOfVisit, mother_followup_id FROM ptme_mother_followup_visit WHERE visit_date < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND voided = 0 GROUP BY mother_followup_id) nbv" +
						"    ON nbv.mother_followup_id = pmf.mother_followup_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = ppp.patient_id" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = ppp.patient_id " +
						"WHERE" +
						"  pmf.pregnancy_outcome IS NULL GROUP BY hiv_care_number " +
						"HAVING ADDDATE(lastVisitDate, INTERVAL 1 MONTH) BETWEEN DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND DATE(LAST_DAY(NOW())) " +
						"ORDER BY AppointmentDate ";
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("pregnantNumber", StandardBasicTypes.STRING)
				.addScalar("hivCareNumber", StandardBasicTypes.STRING)
				.addScalar("numberOfVisit", StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("contact", StandardBasicTypes.STRING)
				.addScalar("appointmentDate", StandardBasicTypes.DATE)
				.addScalar("passed", StandardBasicTypes.INTEGER)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE);

		query.setResultTransformer(new AliasToBeanResultTransformer(MotherFollowupAppointment.class));
		return (List<MotherFollowupAppointment>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<MotherFollowupAppointment> getPregnantPatientsAppointmentMissed() {
		String sqlQuery =
				"SELECT" +
						"  pregnant_number AS pregnantNumber," +
						"  hiv_care_number AS hivCareNumber," +
						"  lastVisitDate," +
						"  numberOfVisit," +
						"  AppointmentDate," +
						"  family_name as familyName," +
						"  given_name as givenName, " +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) contact " +
						"FROM" +
						"  (SELECT * FROM ptme_mother_followup WHERE voided = 0) pmf" +
						"  INNER JOIN (SELECT MAX(visit_date) lastVisitDate, mother_followup_id FROM ptme_mother_followup_visit GROUP BY mother_followup_id) lpmfv" +
						"    ON pmf.mother_followup_id = lpmfv.mother_followup_id" +
						"  LEFT JOIN (SELECT *, ADDDATE(visit_date, INTERVAL 1 MONTH) AppointmentDate FROM ptme_mother_followup_visit) pmfv ON pmf.mother_followup_id = lpmfv.mother_followup_id AND lpmfv.lastVisitDate = pmfv.visit_date" +
						"  LEFT JOIN ptme_pregnant_patient ppp ON pmf.pregnant_patient_id = ppp.pregnant_patient_id" +
						"  LEFT JOIN (SELECT COUNT(mother_followup_visit_id) numberOfVisit, mother_followup_id FROM ptme_mother_followup_visit WHERE visit_date < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) GROUP BY mother_followup_id) nbv" +
						"    ON nbv.mother_followup_id = pmf.mother_followup_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = ppp.patient_id" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = ppp.patient_id " +
						"WHERE" +
						"  pmf.pregnancy_outcome IS NULL GROUP BY hiv_care_number " +
						"HAVING ADDDATE(lastVisitDate, INTERVAL 1 MONTH) < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND " +
						"  ADDDATE(lastVisitDate, INTERVAL 1 MONTH) >= ADDDATE(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')), INTERVAL -3 MONTH) " +
						"ORDER BY lastVisitDate ";
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("pregnantNumber", StandardBasicTypes.STRING)
				.addScalar("hivCareNumber", StandardBasicTypes.STRING)
				.addScalar("numberOfVisit", StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("contact", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("appointmentDate", StandardBasicTypes.DATE)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE);

		query.setResultTransformer(new AliasToBeanResultTransformer(MotherFollowupAppointment.class));
		return (List<MotherFollowupAppointment>) query.list();
	}

	@Override
	public List<MotherFollowupAppointment> getPregnantPatientsAppointmentForCV() {
		String sqlQuery =
				"SELECT" +
						"  pregnant_number AS pregnantNumber," +
						"  hiv_care_number AS hivCareNumber," +
						"  lastVisitDate," +
						"  numberOfVisit," +
						"  AppointmentDate," +
						"  family_name as familyName," +
						"  given_name as givenName, " +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) contact " +
						"FROM" +
						"  (SELECT * FROM ptme_mother_followup WHERE voided = 0) pmf" +
						"  INNER JOIN (SELECT MAX(visit_date) lastVisitDate, mother_followup_id FROM ptme_mother_followup_visit GROUP BY mother_followup_id) lpmfv" +
						"    ON pmf.mother_followup_id = lpmfv.mother_followup_id" +
						"  LEFT JOIN (SELECT *, ADDDATE(visit_date, INTERVAL 1 MONTH) AppointmentDate FROM ptme_mother_followup_visit) pmfv ON pmf.mother_followup_id = lpmfv.mother_followup_id AND lpmfv.lastVisitDate = pmfv.visit_date" +
						"  LEFT JOIN ptme_pregnant_patient ppp ON pmf.pregnant_patient_id = ppp.pregnant_patient_id" +
						"  LEFT JOIN (SELECT COUNT(mother_followup_visit_id) numberOfVisit, mother_followup_id FROM ptme_mother_followup_visit WHERE visit_date < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) GROUP BY mother_followup_id) nbv" +
						"    ON nbv.mother_followup_id = pmf.mother_followup_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = ppp.patient_id" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = ppp.patient_id " +
						"WHERE" +
						"  pmf.pregnancy_outcome IS NULL GROUP BY hiv_care_number " +
						"HAVING ADDDATE(lastVisitDate, INTERVAL 1 MONTH) < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND " +
						"  ADDDATE(lastVisitDate, INTERVAL 1 MONTH) >= ADDDATE(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')), INTERVAL -3 MONTH) " +
						"ORDER BY lastVisitDate ";
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("pregnantNumber", StandardBasicTypes.STRING)
				.addScalar("hivCareNumber", StandardBasicTypes.STRING)
				.addScalar("numberOfVisit", StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("contact", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("appointmentDate", StandardBasicTypes.DATE)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE);

		query.setResultTransformer(new AliasToBeanResultTransformer(MotherFollowupAppointment.class));
		return (List<MotherFollowupAppointment>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ChildFollowupAppointment> getChildByAppointment() {
		String sqlQuery =
				"SELECT" +
						"  child_followup_number AS childFollowupNumber," +
						"  family_name familyName," +
						"  given_name AS givenName," +
						"  lastVisitDate," +
						"  IF(numberOfVisit IS NULL, 0, numberOfVisit) numberOfVisit," +
						"  AppointmentDate, " +
						"  passed," +
						"  birth_date," +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact " +
						"FROM" +
						"  (SELECT * FROM ptme_child WHERE voided = 0) pc" +
						"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id" +
						"  LEFT JOIN (SELECT MAX(visit_date) lastVisitDate, child_id FROM ptme_child_followup_visit GROUP BY child_id) lpcfv" +
						"    ON pc.child_id = lpcfv.child_id" +
						"  LEFT JOIN (SELECT *," +
						"               ADDDATE(visit_date, INTERVAL 1 MONTH) AppointmentDate," +
						"               IF(ADDDATE(visit_date, INTERVAL 1 MONTH) > NOW(), 0, " +
						"                  IF(ADDDATE(visit_date, INTERVAL 1 MONTH) = DATE(NOW()), 1, 2)) passed FROM ptme_child_followup_visit) pcfv ON pc.child_id = pcfv.child_id AND pcfv.visit_date = lpcfv.lastVisitDate" +
						"  LEFT JOIN (SELECT COUNT(child_followup_visit_id) numberOfVisit, child_id FROM ptme_child_followup_visit GROUP BY child_id) cpcfv" +
						"    ON cpcfv.child_id = pc.child_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE" +
						"  pcf.followup_result IS NULL AND (lastVisitDate IS NULL OR NOT (lastVisitDate BETWEEN DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND DATE(LAST_DAY(NOW())))) " +
						"  GROUP BY child_followup_number " +
						"HAVING (lastVisitDate IS NOT NULL AND ADDDATE(lastVisitDate, INTERVAL 1 MONTH) BETWEEN DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND DATE(LAST_DAY(NOW()))) OR " +
						"       (lastVisitDate IS NULL AND (ADDDATE(birth_date, INTERVAL 1 MONTH) BETWEEN DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND DATE(LAST_DAY(NOW())) ))" +
						"ORDER BY AppointmentDate";
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("childFollowupNumber", StandardBasicTypes.STRING)
				.addScalar("numberOfVisit", StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("motherContact", StandardBasicTypes.STRING)
				.addScalar("appointmentDate", StandardBasicTypes.DATE)
				.addScalar("passed", StandardBasicTypes.INTEGER)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE);

		query.setResultTransformer(new AliasToBeanResultTransformer(ChildFollowupAppointment.class));
		return (List<ChildFollowupAppointment>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ChildFollowupAppointment> getChildByAppointmentMissed() {
		String sqlQuery =
				"SELECT" +
						"  child_followup_number AS childFollowupNumber," +
						"  family_name familyName," +
						"  given_name AS givenName," +
						"  lastVisitDate," +
						"  numberOfVisit," +
						"  AppointmentDate, " +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact " +
						"FROM" +
						"  (SELECT * FROM ptme_child WHERE voided = 0) pc" +
						"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id" +
						"  LEFT JOIN (SELECT MAX(visit_date) lastVisitDate, child_id FROM ptme_child_followup_visit GROUP BY child_id) lpcfv" +
						"    ON pc.child_id = lpcfv.child_id" +
						"  LEFT JOIN (SELECT *, ADDDATE(visit_date, INTERVAL 1 MONTH) AppointmentDate FROM ptme_child_followup_visit) pcfv ON pc.child_id = pcfv.child_id AND pcfv.visit_date = lpcfv.lastVisitDate" +
						"  LEFT JOIN (SELECT COUNT(child_followup_visit_id) numberOfVisit, child_id FROM ptme_child_followup_visit WHERE visit_date < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) GROUP BY child_id) cpcfv" +
						"    ON cpcfv.child_id = pc.child_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE" +
						"  pcf.followup_result IS NULL GROUP BY child_followup_number " +
						"HAVING ADDDATE(lastVisitDate, INTERVAL 1 MONTH) < DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')) AND " +
						"  ADDDATE(lastVisitDate, INTERVAL 1 MONTH) >= ADDDATE(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(NOW()), '01')), INTERVAL -3 MONTH) " +
						"ORDER BY lastVisitDate";
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("childFollowupNumber", StandardBasicTypes.STRING)
				.addScalar("numberOfVisit", StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("motherContact", StandardBasicTypes.STRING)
				.addScalar("appointmentDate", StandardBasicTypes.DATE)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE);

		query.setResultTransformer(new AliasToBeanResultTransformer(ChildFollowupAppointment.class));
		return (List<ChildFollowupAppointment>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ChildFollowupAppointment> getChildByAppointmentPcr(String pcrParams, Integer pcrType) {
		/*
		String periodParam = "6:S|8:M";
		String minAgeIn = "S";
		String minAge = "0";
		String maxAgeIn = "S";
		String maxAge = "0";
		if (!pcrParams.isEmpty()) {
			String[] params = periodParam.split("|");
			String[] min = params[0].split(":");
			minAgeIn = min[1].equals("S") ? "7" : "30";
			minAge = min[0];
			if (params.length == 2) {
				String[] max = params[1].split(":");
				maxAgeIn = max[1].equals("S") ? "7" : "30";
				maxAge = max[0];
			}
		}
		String pcrTypeSql = "";
		*/

		String sqlQuery = "";

		if (pcrType != null) {
//			pcrTypeSql = "AND pcf.pcr"+ pcrType.toString() +"_sampling_date IS NULL AND ";
            if (pcrType == 1) {
                sqlQuery =
						"SELECT" +
								"  child_followup_number AS childFollowupNumber," +
								"  family_name familyName," +
								"  given_name AS givenName," +
								"  pc.birth_date As lastVisitDate," +
								"  AppointmentDate," +
								"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
								"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
								"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact, " +
								"  passed, " +
								" 0 AS numberOfVisit " +
								"FROM" +
								" (SELECT *, ADDDATE(birth_date, INTERVAL 6 WEEK) AppointmentDate, " +
								"      IF(ADDDATE(birth_date, INTERVAL 6 WEEK) > NOW(), 0, IF(ADDDATE(birth_date, INTERVAL 6 WEEK) = DATE(NOW()), 1, 2)) passed  FROM ptme_child WHERE voided = 0) pc" +
								"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id " +
								"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
								"    ON SoutTel.person_id = pc.mother" +
								"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
								"    ON SoutCel.person_id = pc.mother " +
								"WHERE" +
								"  pcf.pcr1_sampling_date IS NULL AND " +
								"  ((FLOOR(DATEDIFF(DATE(NOW()), birth_date) /7) >= 6 AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) <= 8" +
								"  AND pcf.hiv_serology1_date IS NULL AND pcf.hiv_serology2_date IS NULL) OR " +
								"  (FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) >= 9 AND pcf.hiv_serology1_result = 1))" +
								"  AND pcf.followup_result IS NULL ";
            } else if (pcrType == 2) {
				sqlQuery =
						"SELECT" +
						"  child_followup_number AS childFollowupNumber," +
						"  family_name familyName," +
						"  given_name AS givenName," +
						"  pc.birth_date As lastVisitDate," +
						"  IF(hiv_serology1_result IS NOT NULL, hiv_serology1_date, pcr1_sampling_date ) AppointmentDate," +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact, " +
						"  IF(hiv_serology1_result IS NOT NULL, 1, 2 ) AS numberOfVisit," +
						"  IF(hiv_serology1_result IS NOT NULL, hiv_serology1_result, pcr1_result ) AS passed " +
						"FROM " +
						"  (SELECT * FROM ptme_child WHERE voided = 0) pc" +
						"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id" +
//						"  LEFT JOIN (SELECT MAX(visit_date) MaxVisiteDateAllt, child_id FROM ptme_child_followup_visit WHERE eating_type = 1 AND visit_date <= DATE(NOW()) AND voided = 0 GROUP BY child_id) MV" +
//						"    ON pc.child_id = MV.child_id" +
//						"  LEFT JOIN (SELECT MAX(visit_date) MaxVisiteDate, child_id FROM ptme_child_followup_visit WHERE eating_type <> 1 AND visit_date <= DATE(NOW()) AND voided = 0 GROUP BY child_id) MV1" +
//						"    ON pc.child_id = MV1.child_id" +
//						"  LEFT JOIN (SELECT child_id, visit_date, eating_type, ADDDATE(visit_date, INTERVAL 6 WEEK) AppointmentDate, " +
//						"                IF(ADDDATE(visit_date, INTERVAL 6 WEEK) > NOW(), 0," +
//						"                 IF(ADDDATE(visit_date, INTERVAL 6 WEEK) = DATE(NOW()), 1, 2)) passed FROM ptme_child_followup_visit WHERE voided = 0) pcfv " +
//						"    ON pcfv.child_id = MV1.child_id AND pcfv.visit_date = MV1.MaxVisiteDate " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE " +
						"  pcf.pcr1_result IS NOT NULL" +
						"  AND pcf.pcr2_sampling_date IS NULL" +
						"  AND (( pcf.pcr1_result = 1 AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) < 9) OR " +
//						"  (MaxVisiteDate IS NOT NULL AND (MaxVisiteDateAllt < MaxVisiteDate) " +
						//"  AND eating_type <> 1 " +
						//"  FLOOR(DATEDIFF(DATE(NOW()), visit_date) /7) >= 6 " +
                        "  ( pcf.pcr1_result = 0 AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) >= 6 AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) < 9) OR " +
						"  (FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) >= 9 AND pcf.hiv_serology1_result = 1)) " +
						"  AND pcf.followup_result IS NULL";
			} else if (pcrType == 3) {
				sqlQuery =
						"SELECT" +
						"  child_followup_number AS childFollowupNumber," +
						"  family_name familyName," +
						"  given_name AS givenName," +
						"  pc.birth_date As lastVisitDate," +
						"  IF(hiv_serology1_date IS NOT NULL, hiv_serology1_date, pcr2_sampling_date ) AppointmentDate," +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact, " +
						"  2 AS passed, " +
						"  0 AS numberOfVisit " +
						"FROM" +
						" (SELECT * FROM ptme_child WHERE voided = 0) pc" +
						"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel" +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE" +
						"  pcf.pcr3_sampling_date IS NULL AND " +
						"  ((pcf.pcr2_result = 1 AND pcf.pcr1_result = 0) OR (pcf.pcr1_result = 1 AND pcf.pcr2_result = 0)) AND " +
						"  pcf.followup_result IS NULL AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) < 9";
			} else if (pcrType == 4) {
				sqlQuery =
						"SELECT" +
						"  child_followup_number AS childFollowupNumber," +
						"  family_name familyName," +
						"  given_name AS givenName," +
						"  pc.birth_date As lastVisitDate," +
						"  BirthDateAfter9Month AppointmentDate," +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact, " +
						"  0 AS passed, " +
						"  0 AS numberOfVisit " +
//						"  IF(IF(EarlistVisitDateNotBreastfeeding <= BirthDateAfter9Month, BirthDateAfter9Month, EarlistVisitDateNotBreastfeeding) > NOW(), 0, " +
//								"IF(IF(EarlistVisitDateNotBreastfeeding <= BirthDateAfter9Month, BirthDateAfter9Month, EarlistVisitDateNotBreastfeeding) = DATE(NOW()), 1, 2)) passed  " +
						"FROM" +
						" (SELECT *, ADDDATE(birth_date, INTERVAL 9 MONTH) BirthDateAfter9Month FROM ptme_child WHERE voided = 0) pc" +
						"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id " +
//						"  LEFT JOIN (SELECT MAX(visit_date) LastVisitDateBreastfeeding, child_id FROM ptme_child_followup_visit WHERE eating_type = 1 GROUP BY child_id) LVDB " +
//						"    ON LVDB.child_id = pc.child_id " +
//						"  LEFT JOIN (SELECT ADDDATE(MIN(visit_date), INTERVAL 6 WEEK) EarlistVisitDateNotBreastfeeding, child_id FROM ptme_child_followup_visit WHERE eating_type <> 1 GROUP BY child_id) LVDNB " +
//						"    ON LVDNB.child_id = pc.child_id AND (LastVisitDateBreastfeeding IS NULL OR LastVisitDateBreastfeeding < EarlistVisitDateNotBreastfeeding) " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE" +
						"  ((pcf.pcr1_sampling_date IS NULL " +
						"  AND ( FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) >= 9 AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) < 18)) OR " +
						"  (pcf.pcr1_sampling_date IS NOT NULL AND pcf.pcr2_sampling_date IS NULL " +
						"  AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) >= 9 AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) < 18))" +
						"  AND pcf.hiv_serology1_date IS NULL " +
						"  AND pcf.followup_result IS NULL " +
						"  AND pc.BirthDateAfter9Month <= LAST_DAY(NOW())";
//						" AND EarlistVisitDateNotBreastfeeding IS NOT NULL " +
//						"HAVING AppointmentDate <= LAST_DAY(NOW())";
			} else if (pcrType == 5) {
				sqlQuery =
						"SELECT" +
						"  child_followup_number AS childFollowupNumber," +
						"  family_name familyName," +
						"  given_name AS givenName," +
						"  pc.birth_date As lastVisitDate," +
						"  AppointmentDate," +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact, " +
						"  0 AS passed, " +
						"  0 AS numberOfVisit " +
						"FROM" +
						" (SELECT *, ADDDATE(birth_date, INTERVAL 18 MONTH) AppointmentDate " +
//						"			,IF(ADDDATE(birth_date, INTERVAL 18 MONTH) > NOW(), 0, IF(ADDDATE(birth_date, INTERVAL 9 MONTH) = DATE(NOW()), 1, 2)) passed " +
						"		FROM ptme_child WHERE voided = 0) pc" +
						"  LEFT JOIN ptme_child_followup pcf ON pc.child_id = pcf.child_followup_id " +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE" +
						"  ((pcf.hiv_serology2_date IS NULL " +
						"  AND FLOOR(DATEDIFF(DATE(NOW()), birth_date) /30) >= 18))" +
						//"  AND pcf.hiv_serology1_date IS NOT NULL " +
						"  AND pcf.followup_result NOT IN (1, 2, 4, 5)";
			}
		}

		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("childFollowupNumber", StandardBasicTypes.STRING)
				.addScalar("passed", StandardBasicTypes.INTEGER)
				.addScalar("numberOfVisit", StandardBasicTypes.INTEGER)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("appointmentDate", StandardBasicTypes.DATE)
				.addScalar("motherContact", StandardBasicTypes.STRING)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE);

		query.setResultTransformer(new AliasToBeanResultTransformer(ChildFollowupAppointment.class));
		return (List<ChildFollowupAppointment>) query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ChildPcrResultWaitingTransformer> getChildPcrResultWaiting() {
		String sqlQuery =
				"SELECT " +
						"  pc.child_id AS childId," +
						"  pc.child_followup_number AS childFollowupNumber," +
						"  birth_date AS birthDate, " +
						"  family_name AS familyName," +
						"  given_name givenName," +
						"  gender," +
						"  IF(pcr3_sampling_date IS NOT NULL, 'PCR 3'," +
						"     IF(pcr2_sampling_date IS NOT NULL, 'PCR 2'," +
						"        IF(pcr1_sampling_date IS NOT NULL, 'PCR 1', NULL)) ) AS pcrRank," +
						"  IF(pcr3_sampling_date IS NOT NULL, pcr3_sampling_date," +
						"     IF(pcr2_sampling_date IS NOT NULL, pcr2_sampling_date," +
						"        IF(pcr1_sampling_date IS NOT NULL, pcr1_sampling_date, NULL)) ) AS samplingDate," +
						"  IF(pcr3_sampling_date IS NOT NULL, pcr3_result," +
						"     IF(pcr2_sampling_date IS NOT NULL, pcr2_result," +
						"        IF(pcr1_sampling_date IS NOT NULL, pcr1_result, NULL)) ) AS lastPCRResult, " +
						"  IF(TelPatient IS NOT NULL AND CelPatient IS NOT NULL, CONCAT_WS(' / ', CelPatient, TelPatient), " +
						"		IF(TelPatient IS NULL AND CelPatient IS NOT NULL, CelPatient, " +
						"		IF(TelPatient IS NOT NULL AND CelPatient IS NULL,TelPatient, NULL))) motherContact," +
						" IF(pcr3_sampling_date IS NOT NULL, DATEDIFF(DATE(NOW()), pcr3_sampling_date)," +
						"    IF(pcr2_sampling_date IS NOT NULL, DATEDIFF(DATE(NOW()), pcr2_sampling_date)," +
						"       IF(pcr1_sampling_date IS NOT NULL, DATEDIFF(DATE(NOW()), pcr1_sampling_date), NULL))) numDay " +
						"FROM " +
						"  (SELECT *, if(followup_result IS NOT NULL, 'Off', 'On') status FROM ptme_child_followup) pcf" +
						"  INNER JOIN  ptme_child pc ON pc.child_id = pcf.child_followup_id" +
						"  LEFT JOIN (SELECT person_id, value_text TelPatient FROM obs o WHERE concept_id = 164500) SoutTel" +
						"    ON SoutTel.person_id = pc.mother" +
						"  LEFT JOIN (SELECT person_id, value_text CelPatient FROM obs o WHERE concept_id = 164501) SoutCel " +
						"    ON SoutCel.person_id = pc.mother " +
						"WHERE" +
//						"  pc.child_id = pcf.child_followup_id AND" +
						"  pcf.status = 'On' AND pcf.voided = false " +
						"HAVING samplingDate IS NOT NULL AND lastPCRResult IS NULL";
		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("childFollowupNumber", StandardBasicTypes.STRING)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("motherContact", StandardBasicTypes.STRING)
				.addScalar("samplingDate", StandardBasicTypes.DATE)
				.addScalar("numDay", StandardBasicTypes.INTEGER)
				.addScalar("pcrRank", StandardBasicTypes.STRING);
		query.setResultTransformer(new AliasToBeanResultTransformer(ChildPcrResultWaitingTransformer.class));
		return (List<ChildPcrResultWaitingTransformer>) query.list();
	}

	@Override
	public Boolean isDead(Patient patient) {
		PregnantPatient pregnantPatient = (PregnantPatient) sessionFactory.getCurrentSession().createQuery("SELECT p FROM PregnantPatient p, Obs o " +
				"WHERE o.person.personId = p.patient.patientId AND o.concept.conceptId = 1543 AND  p.patient = :patient AND " +
				"o.voided = false")
				.setParameter("patient", patient).uniqueResult();
		return pregnantPatient != null;
	}

	@Override
	public Boolean isTransferred(Patient patient) {
		PregnantPatient pregnantPatient = (PregnantPatient) sessionFactory.getCurrentSession().createQuery(
				"SELECT p FROM PregnantPatient p, Obs o " +
						"WHERE p.patient = :patient AND o.person.personId = p.patient.patientId AND o.concept.conceptId = 164595 AND " +
						" o.valueDatetime >= (SELECT MAX(e.encounterDatetime) FROM Encounter e WHERE e.patient = :patient AND e.encounterType.encounterTypeId = 1 AND e.voided = false GROUP BY e.patient) AND " +
						" o.voided = false "
		).setParameter("patient", patient).uniqueResult();
		return pregnantPatient != null;
	}

	@Override
	public Boolean isDeclaredNegative(Patient patient) {
		PregnantPatient pregnantPatient = (PregnantPatient) sessionFactory.getCurrentSession().createQuery("SELECT p FROM PregnantPatient p, Obs o " +
				"WHERE o.person.personId = p.patient.patientId AND o.concept.conceptId = 163511 AND  p.patient = :patient AND " +
				"o.voided = false")
				.setParameter("patient", patient).uniqueResult();
		return pregnantPatient != null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingIndicator> getAllIndicators() {
		return (List<ReportingIndicator>) sessionFactory.getCurrentSession().createCriteria(ReportingIndicator.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingIndicator> getAllIndicators(Boolean includeVoided) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingIndicator.class);
		return (List<ReportingIndicator>) (includeVoided ? criteria.list() : criteria.add(Restrictions.eq("voided", includeVoided)).list());
	}

	@Override
	public ReportingIndicator getIndicatorById(Integer indicatorId) {
		return  (ReportingIndicator) sessionFactory.getCurrentSession().get(ReportingIndicator.class, indicatorId);
	}

	@Transactional
	@Override
	public ReportingIndicator saveReportingIndicator(ReportingIndicator indicator) {
		sessionFactory.getCurrentSession().saveOrUpdate(indicator);
		return indicator;
	}

	@Transactional
	@Override
	public Boolean removeIndicator(Integer indicatorId) {
		if (getIndicatorById(indicatorId) != null){
			sessionFactory.getCurrentSession().delete(getIndicatorById(indicatorId));
			return true;
		}
		return false;
	}

	@Transactional
	@Override
	public ReportingIndicator voidIndicator(Integer indicatorId) {
		ReportingIndicator ri = (ReportingIndicator) sessionFactory.getCurrentSession().get(ReportingIndicator.class, indicatorId);
		ri.setVoided(true);
		ri.setDateVoided(new Date());
		sessionFactory.getCurrentSession().update(ri);
		return ri;
	}

	@Override
	public ReportingIndicator getIndicatorByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingIndicator.class);
		return (ReportingIndicator) criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingDataset> getAllDatasets() {
		return (List<ReportingDataset>) sessionFactory.getCurrentSession().createCriteria(ReportingDataset.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingDataset> getAllDatasets(Boolean includeVoided) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingDataset.class);
		return (List<ReportingDataset>) (includeVoided ? criteria.list() : criteria.add(Restrictions.eq("voided", includeVoided)).list());
	}

	@Override
	public ReportingDataset getDatasetById(Integer indicatorId) {
		return  (ReportingDataset) sessionFactory.getCurrentSession().get(ReportingDataset.class, indicatorId);
	}

	@Transactional
	@Override
	public ReportingDataset saveReportingDataset(ReportingDataset dataset) {
		sessionFactory.getCurrentSession().saveOrUpdate(dataset);
		return dataset;
	}

	@Transactional
	@Override
	public Boolean removeDataset(Integer datasetId) {
		if (getDatasetById(datasetId) != null){
			sessionFactory.getCurrentSession().delete(getIndicatorById(datasetId));
			return true;
		}
		return false;
	}

	@Transactional
	@Override
	public ReportingDataset voidDataset(Integer indicatorId) {
		ReportingDataset rd = (ReportingDataset) sessionFactory.getCurrentSession().get(ReportingDataset.class, indicatorId);
		rd.setVoided(true);
		rd.setDateVoided(new Date());
		sessionFactory.getCurrentSession().update(rd);
		return rd;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingReport> getAllReports() {
		return (List<ReportingReport>) sessionFactory.getCurrentSession().createCriteria(ReportingReport.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingReport> getAllReports(Boolean includeVoided) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingReport.class);
		return (List<ReportingReport>) (includeVoided ? criteria.list() : criteria.add(Restrictions.eq("voided", includeVoided)).list());
	}

	@Override
	public ReportingReport getReportById(Integer reportId) {
		return (ReportingReport) sessionFactory.getCurrentSession().get(ReportingReport.class, reportId);
	}

	@Transactional
	@Override
	public ReportingReport saveReportingReport(ReportingReport report) {
		sessionFactory.getCurrentSession().saveOrUpdate(report);
		return report;
	}

	@Transactional
	@Override
	public Boolean removeReport(Integer reportId) {
		if (getDatasetById(reportId) != null){
			sessionFactory.getCurrentSession().delete(getIndicatorById(reportId));
			return true;
		}
		return false;
	}

	@Transactional
	@Override
	public ReportingReport voidReport(Integer reportId) {
		ReportingReport reportingReport = (ReportingReport) sessionFactory.getCurrentSession().get(ReportingReport.class, reportId);
		reportingReport.setVoided(true);
		reportingReport.setDateVoided(new Date());
		sessionFactory.getCurrentSession().update(reportingReport);
		return reportingReport;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingTemplate> getAllTemplates() {
		return (List<ReportingTemplate>) sessionFactory.getCurrentSession().createCriteria(ReportingTemplate.class).list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingTemplate> getAllTemplates(Boolean includeVoided) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingTemplate.class);
		return (List<ReportingTemplate>) (includeVoided ? criteria.list() : criteria.add(Restrictions.eq("voided", includeVoided)).list());
	}

	@Override
	public ReportingTemplate getTemplateById(Integer templateId) {
		return (ReportingTemplate) sessionFactory.getCurrentSession().get(ReportingTemplate.class, templateId);
	}

	@Override
	public ReportingTemplate getTemplateByName(String name) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingTemplate.class);
		return (ReportingTemplate) criteria.add(Restrictions.eq("name", name)).uniqueResult();
	}

	@Transactional
	@Override
	public ReportingTemplate saveReportingTemplate(ReportingTemplate template) {
		sessionFactory.getCurrentSession().saveOrUpdate(template);
		return template;
	}


	@Transactional
	@Override
	public Boolean removeTemplate(Integer templateId) {
		if (getTemplateById(templateId) != null){
			sessionFactory.getCurrentSession().delete(getTemplateById(templateId));
			return true;
		}
		return false;
	}

	@Transactional
	@Override
	public ReportingTemplate voidTemplate(Integer templateId) {
		ReportingTemplate ri = (ReportingTemplate) sessionFactory.getCurrentSession().get(ReportingTemplate.class, templateId);
		ri.setVoided(true);
		ri.setDateVoided(new Date());
		sessionFactory.getCurrentSession().update(ri);
		return ri;
	}

	@Override
	public SerializedData getSerializedDataById(Integer id) {
		return (SerializedData) sessionFactory.getCurrentSession().get(SerializedData.class, id);
	}

	@Override
	public SerializedData getSerializedDataByObjectUuid(String objectUuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(SerializedData.class);
		return (SerializedData) criteria.add(Restrictions.eq("objectUuid", objectUuid)).uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<SerializedData> getAllSerializedData() {
		return (List<SerializedData>) sessionFactory.getCurrentSession().createCriteria(SerializedData.class).list();
	}

	@Transactional
	@Override
	public SerializedData saveSerializedData(SerializedData serializedData) {
		sessionFactory.getCurrentSession().saveOrUpdate(serializedData);
		return serializedData;
	}

	@Transactional
	@Override
	public Boolean removeSerializedDataById(Integer id) {
		if (getSerializedDataById(id) != null) {
			sessionFactory.getCurrentSession().delete(getSerializedDataById(id));
			return true;
		}
		return false;
	}

	@Override
	public ReportingReportGeneration getGeneratedReport(Integer generatedReportId) {
		return (ReportingReportGeneration) sessionFactory.getCurrentSession().get(ReportingReportGeneration.class, generatedReportId);
	}

	@Override
	public Location getLocationByName(String name) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Location.class);
		return (Location) criteria.add(Restrictions.eq("name", name)).uniqueResult();
	}

	@Override
	public ReportingIndicator getIndicatorByName(String name) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingIndicator.class);
		return (ReportingIndicator) criteria.add(Restrictions.eq("name", name)).uniqueResult();
	}

	@Override
	public ReportingIndicator getIndicatorByCode(String code) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingIndicator.class);
		return (ReportingIndicator) criteria.add(Restrictions.eq("templateCode", code)).uniqueResult();
	}

	@Override
	public ReportingReportGeneration getGeneratedReportByName(String name) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingReportGeneration.class);
		return (ReportingReportGeneration) criteria.add(Restrictions.eq("name", name)).uniqueResult();
	}

	@Override
	public ReportingReportGeneration getGeneratedReportByNameAndReportId(String name, Integer reportId) {
		return (ReportingReportGeneration) sessionFactory.getCurrentSession().createQuery("FROM " +
				"ReportingReportGeneration r WHERE r.name = :name AND r.report.reportId = :reportId AND r.voided = false")
				.setParameter("reportId", reportId)
				.setParameter("name", name)
				.uniqueResult();
	}

	@Override
	public String getGeneratedReportXmlString(Date startDate, Date endDate, Integer reportId, String location) {
//		Location l = Context.getLocationService().getDefaultLocation();
		Location l = getLocationByName(location);
		ReportIndicatorValues reportIndicatorValues = new ReportIndicatorValues();


//		System.out.println("Param location name : " + getLocationByName(location).getName());
//		System.out.println("Param location name after checking in data : " + getLocationByName(location).getName());

		reportIndicatorValues.setGenerationDate(new Date());
		reportIndicatorValues.setReportStartDate(startDate);
		reportIndicatorValues.setReportEndDate(endDate);
		Integer locationId = null;

		if (l != null) {
			reportIndicatorValues.setLocationUuid(l.getUuid());
			locationId = l.getLocationId();
		}

		ReportingReport report = getReportById(reportId);
		List<ReportDataSetIndicatorRun> reportDataSetIndicatorRuns = new ArrayList<ReportDataSetIndicatorRun>();

		for (ReportingDataset reportingDataset : report.getReportingDatasets()) {

			ReportDataSetIndicatorRun reportDataSetIndicatorRun = new ReportDataSetIndicatorRun();
			reportDataSetIndicatorRun.setDataSetUuid(reportingDataset.getUuid());

			List<ReportRunIndicatorValue> reportRunIndicatorValues = new ArrayList<ReportRunIndicatorValue>();

			for (ReportingIndicator reportingIndicator : reportingDataset.getReportingIndicators()) {
				ReportRunIndicatorValue reportRunIndicatorValue = new ReportRunIndicatorValue();

				String sqlQuery = reportingIndicator.getIndicatorSqlScript();

				Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery);
				if (sqlQuery.contains(":startDate")) {
					query.setParameter("startDate", startDate);
				}
				if (sqlQuery.contains(":endDate")) {
					query.setParameter("endDate", endDate);
				}
				if (sqlQuery.contains(":locationId")) {
					query.setParameter("locationId", locationId);
				}

				String value = query.uniqueResult().toString();

				reportRunIndicatorValue.setValue(Integer.parseInt(value));
				reportRunIndicatorValue.setIndicatorUuid(reportingIndicator.getUuid());
				reportRunIndicatorValue.setCode(reportingDataset.getCode() + "." + reportingIndicator.getTemplateCode());

				reportRunIndicatorValues.add(reportRunIndicatorValue);
			}

			reportDataSetIndicatorRun.setReportRunIndicatorValues(reportRunIndicatorValues);
			reportDataSetIndicatorRuns.add(reportDataSetIndicatorRun);
		}

		//reportIndicatorValues.setReportRunIndicatorValues(reportRunIndicatorValues);

		reportIndicatorValues.setReportDataSetIndicatorRuns(reportDataSetIndicatorRuns);

		XStream xStream = new XStream(new DomDriver());
		xStream.registerConverter(new ReportIndicatorValuesXml());
		xStream.alias("report", ReportIndicatorValues.class);

		return xStream.toXML(reportIndicatorValues);
	}

	@Transactional
	@Override
	public ReportingReportGeneration saveGenerationReport(ReportingReportGeneration reportingReportGeneration) {
		sessionFactory.getCurrentSession().saveOrUpdate(reportingReportGeneration);
		return reportingReportGeneration;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ReportingReportGeneration> getAllGeneratedReport(Boolean includeVoided) {
		return (List<ReportingReportGeneration>) sessionFactory.getCurrentSession().createCriteria(ReportingReportGeneration.class).list();
	}

	@Override
	public ReportingDataset getDatasetByUuid(String uuid) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(ReportingDataset.class);
		return (ReportingDataset) criteria.add(Restrictions.eq("uuid", uuid)).uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public Boolean removeGeneratedReport(Integer delId) {
		if (getGeneratedReport(delId) != null){
			sessionFactory.getCurrentSession().delete(getGeneratedReport(delId));
			return true;
		}
		return false;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<MotherFollowupCurrentlyOn> getMotherFollowupList(Date startDate, Date endDate, String status, Integer pregnancyOutcome, String startOrEnd) {
		String sqlQuery =
				"SELECT " +
						"  pmf.mother_followup_id as motherFollowupId," +
						"  hiv_care_number as hivCareNumber," +
						"  age, " +
						"  family_name as familyName, " +
						"  given_name as givenName, " +
						"  arv_status_at_registering as arvStatusAtRegistering, " +
						"  visitCount, " +
						"  start_date as startDate," +
						"  end_date as endDate," +
						"  if(pregnancy_outcome IS NULL AND DateTransfert IS NULL AND DateDeces IS NULL AND DateNotPositive IS NULL, 'On', 'Off') status, " +
						"  lastVisitDate," +
						"  if(DateDeces IS NOT NULL AND pregnancy_outcome IS NULL , 6, if(DateTransfert IS NOT NULL AND pregnancy_outcome IS NULL, 7, if( DateNotPositive IS NOT NULL AND pregnancy_outcome IS NULL , 8, pregnancy_outcome ))) as pregnancyOutcome," +
						"  delivery_type as deliveryType," +
						"  pmf.spousal_screening_date as spousalScreeningDate," +
						"  pmf.spousal_screening_result as spousalScreeningResult " +
						"FROM " +
						"  (" +
						"    SELECT mother_followup_id, arv_status_at_registering, start_date, end_date, " +
						"           pregnancy_outcome, " +
						"           delivery_type, spousal_screening_date, f.spousal_screening_result," +
						"           hiv_care_number, age, family_name, given_name, f.voided, T.value_datetime DateTransfert, D.value_datetime DateDeces, F.value_datetime DateNotPositive FROM ptme_mother_followup f" +
						"    INNER JOIN ptme_pregnant_patient ppp  ON f.pregnant_patient_id = ppp.pregnant_patient_id" +
						"    LEFT JOIN (SELECT person_id, value_datetime FROM obs WHERE concept_id = 1543 AND value_datetime "+ (endDate != null ? "<= :endDate" : " = NOW()") +" AND voided = 0) D ON D.person_id = ppp.patient_id" +
						"    LEFT JOIN (SELECT person_id, value_datetime FROM obs o WHERE concept_id = 164595 AND voided = 0 " +
						"                AND value_datetime > (SELECT MAX(encounter_datetime) FROM encounter " +
						"                                       WHERE encounter_type = 1 AND patient_id = o.person_id GROUP BY patient_id)) T " +
						"      ON T.person_id = ppp.patient_id " +
						"    LEFT JOIN (SELECT person_id, value_datetime FROM obs WHERE concept_id = 163511 AND voided = 0) F ON F.person_id = ppp.patient_id" +
						"  ) pmf, " +

						"  ( SELECT count(*) visitCount, mother_followup_id FROM ptme_mother_followup_visit GROUP BY mother_followup_id) pmfv2, " +
						"  ( SELECT max(visit_date) lastVisitDate, mother_followup_id FROM ptme_mother_followup_visit GROUP BY mother_followup_id) pmfv3 " +
						"WHERE " +
						//"  pmf.pregnant_patient_id = ppp.pregnant_patient_id AND " +
						"  pmf.mother_followup_id = pmfv2.mother_followup_id AND " +
						"  pmf.mother_followup_id = pmfv3.mother_followup_id AND " +
						"  pmf.voided = 0 ";

//		if (startDate != null)
//			sqlQuery = sqlQuery + " AND pmf.start_date = :startDate";

//		if (endDate != null)
//			sqlQuery = sqlQuery + " AND pmf.end_date = :endDate";
		if (pregnancyOutcome != null)
			sqlQuery = sqlQuery + " AND pmf.pregnacy_outcome = :pregnancyOutcome";
		if (startOrEnd != null) {
			if (startOrEnd.equals("startDate")) {
				sqlQuery = sqlQuery + " AND pmf.start_date BETWEEN :startDate AND :endDate";
			} else {
				sqlQuery = sqlQuery + " AND pmf.end_date BETWEEN :startDate AND :endDate";
			}
		}
		if (status != null)
			sqlQuery = sqlQuery + " HAVING status = :status";

		Query query = sessionFactory.getCurrentSession().createSQLQuery(sqlQuery)
				.addScalar("motherFollowupId", StandardBasicTypes.INTEGER)
				.addScalar("hivCareNumber", StandardBasicTypes.STRING)
				.addScalar("familyName", StandardBasicTypes.STRING)
				.addScalar("givenName", StandardBasicTypes.STRING)
				.addScalar("status", StandardBasicTypes.STRING)
				.addScalar("arvStatusAtRegistering", StandardBasicTypes.INTEGER)
				.addScalar("visitCount", StandardBasicTypes.INTEGER)
				.addScalar("lastVisitDate", StandardBasicTypes.DATE)
				.addScalar("startDate", StandardBasicTypes.DATE)
				.addScalar("endDate", StandardBasicTypes.DATE)
				.addScalar("pregnancyOutcome", StandardBasicTypes.INTEGER)
				.addScalar("deliveryType", StandardBasicTypes.INTEGER)
				.addScalar("spousalScreeningDate", StandardBasicTypes.DATE)
				.addScalar("spousalScreeningResult", StandardBasicTypes.INTEGER);

		if (startDate != null)
			query.setParameter("startDate", startDate);
		if (endDate != null)
			query.setParameter("endDate", endDate);
		if (status != null)
			query.setParameter("status", status);
		if (pregnancyOutcome != null)
			query.setParameter("pregnancyOutcome", pregnancyOutcome);
		if (startOrEnd != null) {
			query.setParameter("startDate", startDate);
			query.setParameter("endDate", endDate);
		}

		query.setResultTransformer(new AliasToBeanResultTransformer(MotherFollowupCurrentlyOn.class));

		return (List<MotherFollowupCurrentlyOn>) query.list();
	}
}
