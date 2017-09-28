package com.github.bjuvensjo.maven.repository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@WebServlet("/repository/*")
public class Repository extends HttpServlet {
    private Logger log = LoggerFactory.getLogger(Repository.class);
    private static final String REFS_PARAMATER = "refs";
    private static final String RESOURCE_PARAMATER = "resource";
    private File rootPath;

    @Override
    public void init(ServletConfig config) throws ServletException {
        rootPath = new File(System.getProperty("rootPath"));
        log.info("rootPath: " + rootPath);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<String> refs = Arrays.asList(req.getParameter(REFS_PARAMATER).split(" *, *"));
        String resource = req.getParameter(RESOURCE_PARAMATER);

        Optional<File> file = refs.stream()
                .map(ref -> new File(rootPath, ref + resource))
                .filter(File::exists)
                .findFirst();

        if (file.isPresent()) {
            try {
                log.info("Found: {}", file.get().getCanonicalPath());
                resp.getOutputStream().write(Files.readAllBytes(file.get().toPath()));
            } catch (Exception e) {
                log.error(e.getMessage(), e);
                resp.setStatus(500);
            }
        } else {
            log.info("Could not find: {} in {}", resource, req.getParameter(REFS_PARAMATER));
            resp.setStatus(404);
        }
    }
}
