Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02335529F0
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 06:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbiFUDl1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 20 Jun 2022 23:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiFUDl1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 20 Jun 2022 23:41:27 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FB4631E
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 20:41:26 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a11so5157173ljb.5
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jun 2022 20:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iWpVS5QHohXH6PwK3JJtbHVTjC4HsM+W72+lTslswj8=;
        b=C3dk/g8FIC19jdwBSFAUvVU/WpsxTtThr2K2w6nGleWKl1rRup00B5GwSJDLNn0pPH
         AWBS8Udw399NqVDpixmQ3n5tHTnXPaZHmduEqBm/kfS8A5e5yZfaI0pf8z3ZUXZdjAeB
         SV16JBqp/pyqnKa+XE8YWRG1dUKI7LUcG59DGIHGb2qbIV6JhqNqVL4VtKouWRpC8pfM
         vN8XJ3xS1+s517pKLV7KgNQZ5ImebfWi75DiKww1MjRkfGDO4iBmqsS4n3JazYmKnXSP
         6Lc58PF3DsH3mc+JyK5THNd0g+fWOb0whuQ9jSrB6ciX/ndaZHG8JywavIIJf02rbZDA
         DFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iWpVS5QHohXH6PwK3JJtbHVTjC4HsM+W72+lTslswj8=;
        b=EuXtogQ9mKFdUjePZSGXztptpFm2OwBC3IYLpLNuKYSON3n2/2DJbyO46YW01hv4nu
         /35Wu5H3HmDu1Uh1z4KiJJFSx83r+mqMfuZVYuWeCP8Ss3LVEXoCeudaT7SLhTKM+443
         uiigdhZssG9tKLj1wZSvp1ovVWtcJfV/zJ9NWw1jZArBCL2cOLprpE+3cjwdVpc2+u+q
         Jx+YeWbCccNJeDiaC5ryXl7P56dwDGD9V6uqokRjY75W61zUhBn6FyiahXj8Uj7OdDZK
         wxSj027snve7FKFalOjlfM9TG1sFZjlNmPM2IqyL/9JeSt4de+RK43BDMrdOUgVt5wVv
         KCrQ==
X-Gm-Message-State: AJIora+kecuRLGQQvrJZIlqPR8uX7Vz/HWHpdFErlO0q8sRgLTeULJuD
        JPhVjw+zv5fxmw7fdmMUrJPe73WV3dJwn7z6UffRidHfBk1gYw==
X-Google-Smtp-Source: AGRyM1vLSToJLZVdhy7iDfP2UM3gggPcrnfirFZppM3I7A4bMB01Dm5xUMhjWQHRFv+Q+bbh3PxPp64Y18hCcFjQ+nw=
X-Received: by 2002:a05:651c:20d:b0:255:7ad5:50c2 with SMTP id
 y13-20020a05651c020d00b002557ad550c2mr12795752ljn.438.1655782882509; Mon, 20
 Jun 2022 20:41:22 -0700 (PDT)
MIME-Version: 1.0
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Tue, 21 Jun 2022 09:11:10 +0530
Message-ID: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
Subject: trying to reproduce bcache journal deadlock https://www.spinics.net/lists/kernel/msg4386275.html
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello all,

I am trying to reproduce the problem that
32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure how.
This is to verify and test its backport
(https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for the
help with that backport!)

Could this be reproduced by creating a bcache device with a smaller
journal size? And if so, is there some way to pass the journal size
argument during the creation of the bcache device?

Regards,
Nikhil.
