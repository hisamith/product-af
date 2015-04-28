package org.wso2.carbon.appfactory.jenkins.extentions;

import hudson.Extension;
import hudson.FilePath;
import hudson.maven.AbstractMavenBuild;
import hudson.maven.local_repo.LocalRepositoryLocator;
import hudson.maven.local_repo.LocalRepositoryLocatorDescriptor;
import org.kohsuke.stapler.DataBoundConstructor;

import java.io.File;

/**
 * Created by samith on 4/27/15.
 */
public class TestJobLocalRepositoryLocator extends LocalRepositoryLocator {
    @DataBoundConstructor
    public TestJobLocalRepositoryLocator() {
    }

    public FilePath locate(AbstractMavenBuild build) {
        File dfd = new File("/home/samith/WSO2/AppFactory/Redmine/Jenkins_3757/Deploymnet/test1/run/sampleWS" +
                            "/one/.repository");
        FilePath ddd = new FilePath(dfd);
        return ddd;
    }

    @Extension
    public static class DescriptorImpl extends LocalRepositoryLocatorDescriptor {
        public DescriptorImpl() {
        }

        public String getDisplayName() {
            return "Local to the tensnt workspace";
        }
    }
}