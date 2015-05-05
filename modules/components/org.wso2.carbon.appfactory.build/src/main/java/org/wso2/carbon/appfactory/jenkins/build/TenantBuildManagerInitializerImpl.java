/*
 * Copyright 2005-2011 WSO2, Inc. (http://wso2.com)
 *
 *      Licensed under the Apache License, Version 2.0 (the "License");
 *      you may not use this file except in compliance with the License.
 *      You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *      Unless required by applicable law or agreed to in writing, software
 *      distributed under the License is distributed on an "AS IS" BASIS,
 *      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *      See the License for the specific language governing permissions and
 *      limitations under the License.
 */
package org.wso2.carbon.appfactory.jenkins.build;

import java.io.File;
import java.io.InputStream;
import java.rmi.RemoteException;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.impl.builder.StAXOMBuilder;
import org.apache.axiom.om.xpath.AXIOMXPath;
import org.apache.axis2.AxisFault;
import org.apache.axis2.client.ServiceClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.wso2.carbon.appfactory.buildserver.teanant.mgt.stub.BuildServerManagementServiceBuildServerManagementExceptionException;
import org.wso2.carbon.appfactory.buildserver.teanant.mgt.stub.BuildServerManagementServiceStub;
import org.wso2.carbon.appfactory.common.AppFactoryConstants;
import org.wso2.carbon.appfactory.common.AppFactoryException;
import org.wso2.carbon.appfactory.core.TenantBuildManagerInitializer;
import org.wso2.carbon.appfactory.jenkins.build.internal.ServiceContainer;
import org.wso2.carbon.utils.CarbonUtils;

/**
 * Default implementation of {@link TenantBuildManagerInitializer}
 */
public class TenantBuildManagerInitializerImpl implements
		TenantBuildManagerInitializer {
	private static final Log log = LogFactory
			.getLog(TenantBuildManagerInitializerImpl.class);

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void onTenantCreation(String tenantDomain, String usagePlan) {
		log.info("**********************Initializing build manager for "
				+ tenantDomain + " with " + usagePlan + " *************");
		try {
			
			String endPoint = ServiceContainer.getAppFactoryConfiguration().
                    getFirstProperty(JenkinsCIConstants.BASE_URL_CONFIG_SELECTOR) + "/services/BuildServerManagementService";
			
			BuildServerManagementServiceStub buildServerMgr = new BuildServerManagementServiceStub(endPoint);
			ServiceClient client = buildServerMgr._getServiceClient();
			CarbonUtils.setBasicAccessSecurityHeaders(
					ServiceContainer.getAppFactoryConfiguration()
							.getFirstProperty(
									AppFactoryConstants.SERVER_ADMIN_NAME),
					ServiceContainer.getAppFactoryConfiguration()
							.getFirstProperty(
									AppFactoryConstants.SERVER_ADMIN_PASSWORD),
					client);
			buildServerMgr.createTenant(tenantDomain);

		} catch (AxisFault e) {
			String msg = "Problem occurred when creaing tenant in build server";
			log.error(msg, e);
		} catch (RemoteException e) {
			String msg = "Problem occurred when creaing tenant in build server";
			log.error(msg, e);
		} catch (BuildServerManagementServiceBuildServerManagementExceptionException e) {
			String msg = "Problem occurred when creaing tenant in build server";
			log.error(msg, e);
		}

	}

	/**
	 * Set values in OmElement
	 *
	 * @param template Jenkins job configuration template
	 * @param selector Selector of the template
	 * @param value    related value from the project
	 * @throws org.wso2.carbon.appfactory.common.AppFactoryException
	 */
	protected void setValueUsingXpath(OMElement template, String selector, String value)
			throws AppFactoryException {

		try {
			AXIOMXPath axiomxPath = new AXIOMXPath(selector);
			Object selectedObject = axiomxPath.selectSingleNode(template);

			if (selectedObject != null && selectedObject instanceof OMElement) {
				OMElement svnRepoPathElement = (OMElement) selectedObject;
				svnRepoPathElement.setText(value);
			} else {
				log.warn("Unable to find xml element matching selector : " + selector);
			}

		} catch (Exception e) {
			String msg = "Error while setting values using Xpath selector:" + selector;
			log.error(msg, e);
			throw new AppFactoryException(msg, e);
		}
	}

	protected void test(String tenantDomain) throws AppFactoryException {
		InputStream inputStream =
				this.getClass().getResourceAsStream(File.separator + "samtest_config.xml");
		StAXOMBuilder builder = new StAXOMBuilder(inputStream);
		OMElement buildTemplate = builder.getDocumentElement();
		setValueUsingXpath(buildTemplate,
		                   "displayName",
		                   tenantDomain);
		setValueUsingXpath(buildTemplate,
		                   "description",
		                   "Sample for "+tenantDomain);
		NameValuePair[] queryParams = { new NameValuePair(AppFactoryConstants.JOB_NAME_KEY, tenantDomain) };
	}
}
