Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCB1390B01
	for <lists+linux-bcache@lfdr.de>; Tue, 25 May 2021 23:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhEYVHG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 May 2021 17:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhEYVHF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 May 2021 17:07:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED80C061574
        for <linux-bcache@vger.kernel.org>; Tue, 25 May 2021 14:05:35 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id c20so49539146ejm.3
        for <linux-bcache@vger.kernel.org>; Tue, 25 May 2021 14:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vh4Y5oSvfCLd7BU9KHaFxMu0Fxq/DYXyt+pqODhP7cA=;
        b=a1RUdDMSGi+kcv4BmFbxDLhZqWU5dMWdU6Z+e2zFvGfqpec/1iv7abO37ddJEHHBeY
         zHAPTh2uIRhURu0dGqAMxJBg2YzI5FRUpkP5KAZdtyfBHq1LvzpOJAeZKmQPHPHBMSWu
         JIQEwgJJBVsHvJQmbV1oohmofn9VosSZRVkBhOX27KS2BCPrMqqZEK3kvHMM2eyfL7Yn
         Ievv0RaXWTl6ddJ4aFwo+VEVdiCASeA7Zo8pNPPglCb2PxCq16zSo4R4t4gVzoNcLFn6
         f9PFWrP4b60IlNPIrKQFrJubP7eLnhRX2/5CMIfWckepgWkctxhwGFMlWD5WHpXT1cht
         8dCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vh4Y5oSvfCLd7BU9KHaFxMu0Fxq/DYXyt+pqODhP7cA=;
        b=qcGVDj0QvPLroNTuWsugpbUHdVqus7y1C6gJ8XK4nEr3orycwnPWs0s0rBtXsZC/3y
         /eAll/DDpdPJsCQNrtQ8Gug6XrlkeOG20y7bsiJUGDVyYuvzEQc+HDJb4sSkJeC02U28
         Pj8giU30ps/T4ohPREr3mz6n/uqSIsBuFPefBImwpYwP/mXykAC0tj/JbTKNSo5MPB1e
         IeDh7z0sajy2s7PckkuJ+5n7ihO2Fl8SU2Q+XBx6LvQ2/UcFlkwGKyVvfP8/lY+uViyf
         dKwPvkEVJl95p/7iQnhq24JkvlnxrVcIJjfkiuz2ohXbA8wo0RkLDGs9O7nR8Z0NAZVk
         OkhQ==
X-Gm-Message-State: AOAM531JmMdSkdk7R4ZFF7N693LSmMKohUiAMQYY6v6Uu3Vs082wSFi8
        fN3aQxdNyUE6OIwZEcoraw3E0q9Mqgk=
X-Google-Smtp-Source: ABdhPJxk+tM8pP9srXbyc9bDPLwKvXi6Mt2ctc+T2D0eA2YS1gkrKNy2imVtX6bFt3sST6t+Ik3W5Q==
X-Received: by 2002:a17:907:105e:: with SMTP id oy30mr30476689ejb.258.1621976733932;
        Tue, 25 May 2021 14:05:33 -0700 (PDT)
Received: from exnet.gdb.it (mob-5-90-82-147.net.vodafone.it. [5.90.82.147])
        by smtp.gmail.com with ESMTPSA id b16sm11527478edu.53.2021.05.25.14.05.32
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:05:33 -0700 (PDT)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [BCACHE KERNEL OOPS AND PANIC] System not boot on fedora 34 with 5.12.5-6 kernel versions
Date:   Tue, 25 May 2021 23:04:50 +0200
Message-ID: <2214829.ElGaqSPkdT@exnet.gdb.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

On fedora 34 with 5.12.5-6 kernel version, kernel oops and panic on booting 
when accessing the nvme cache device (I don't know a way to report the many 
kernel messages, the system won't boot).

Detaching the cache device from the bcache device, the system boot.

gdb


