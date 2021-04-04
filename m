Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501DC3538D4
	for <lists+linux-bcache@lfdr.de>; Sun,  4 Apr 2021 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhDDQXv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 4 Apr 2021 12:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhDDQXv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Apr 2021 12:23:51 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3CDC061756
        for <linux-bcache@vger.kernel.org>; Sun,  4 Apr 2021 09:23:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id m3so466955edv.5
        for <linux-bcache@vger.kernel.org>; Sun, 04 Apr 2021 09:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRbfSCYJ4blehV0uU8GLq4Xk3woSMBSdne0gifE4TyA=;
        b=bhkYRKUAkus/uRi85dd9ASDJf7T3mYi0as3hWMlAjar82Mq8LPRER1zBzIl8aDulOV
         yMvPKtVVjt9PN3MPksXEm3tm/jtAMxUBZIbCKuyMPcXbl0faMxMwVeeLvJ1oTtgmfhrS
         0ZjGZHpFteXFQCvg1MCKLDNtbHYN5ISegVPc4KXeKzMw4Wtg5bP3JBqEzhQnZ/tLGYv3
         Fz0v1b+Rrfitt0xayX+ankZOqdBxQQ+pC1/Z9gZOL/MKpDbwj2KYr5OStYaSQGkX+3tf
         Ji+oi4GNluwtPmi+zYbbAnvnw3zPqLLiYTBNCY6BEjaMHaV0nrqfAiniCZmhswhwUxeI
         KJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mRbfSCYJ4blehV0uU8GLq4Xk3woSMBSdne0gifE4TyA=;
        b=gAGgC3kGuRwlrBcRMyMEvOgZD3WKxlS2av4WFaHcqEcGR/phZY9iZxCioU5yLbYNe2
         F5kkdgW22ddwz7NzN27Os/y2rWrCoXxGzycDZwBcHnzooAW7zso6CPpvYDq6ngCJ424Z
         Er0JBtKoKUT+TrtuIFddN8GXk0qbOXkLqjGa/eK5Oqd8PGcCY1594AUS14Yf/F+IPYoG
         CzJUqNymwc8Z7A8+sd2Wp0jAfJ+LqwyZREv6dAC7BH36cRibNlOwm2+bpCI+cARQlFOP
         TCMid1MKHagah7wNdknrS29xWN8Upx3lqINokJsB7GIvWuaYVJ3SGJjzwQiH8i661ZTc
         Vuvw==
X-Gm-Message-State: AOAM5339xYV3Ozy1QvC0YpwFrK+/eNs/52cgE8YukUaU2NeklyduI//r
        IX3T/bCCgFhFMQVczB2SyjhFjFwREwqBzw==
X-Google-Smtp-Source: ABdhPJzuDGKaqJwy38CT39iP+zf3MGk1jBxWd38M0z2w+cAi1H4RHgnkgSA5EaT7Wg1nsAEEc4Ykjg==
X-Received: by 2002:a05:6402:c8:: with SMTP id i8mr27135882edu.57.1617553423195;
        Sun, 04 Apr 2021 09:23:43 -0700 (PDT)
Received: from exnet.gdb.it (mob-5-90-68-228.net.vodafone.it. [5.90.68.228])
        by smtp.gmail.com with ESMTPSA id a9sm8798576edt.82.2021.04.04.09.23.42
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 09:23:42 -0700 (PDT)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [CACHE DEVICE] Space usage
Date:   Sun, 04 Apr 2021 18:15:51 +0200
Message-ID: <4639704.31r3eYUQgx@exnet.gdb.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

In SSDs, full use of available space causes speed and durability problems.

bcahe uses all the available space in the cache device? 

I could not find information on the maximum space used or how to set it. 


gdb


