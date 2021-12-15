Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5509747515E
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Dec 2021 04:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbhLODdF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Dec 2021 22:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhLODdF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Dec 2021 22:33:05 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88B7C061574
        for <linux-bcache@vger.kernel.org>; Tue, 14 Dec 2021 19:33:04 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d14so16418285ila.1
        for <linux-bcache@vger.kernel.org>; Tue, 14 Dec 2021 19:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Uwm/hlzmnNXIPFT+EQgKwvN9+qm6zMRjD06gitahOQI=;
        b=4Udac/HnuW3NMh1q8GSYjyWaQ5sCCmgmguKGKwB99nzUaxxgda+bz4hvZlMHOPQK5I
         n1WfiumVeOMF5xk9Cp1oBe5pCC9xmowIZqF0tcfj/m2P7rZPpM1Ign1oXwNj1Q8khJVh
         Sc1Y9atQC8yPlEYbbz5DYdTZKTjH5F/Ry8x0ZW5zxLCnHqgyr5ekB6zHn0mbUPvD1d5P
         hoQ4DGV76taxQTIF4J8KTFTTu0Br9pdnkacPYbSbjkLyBYIeqXLxlK6j6iKzYFEo9xa0
         P2TguPBuU9kXKB3T05KNQpiqbXIO9vcyCa/T2zZY0Ht5xiXjt7R9ZAsOX7lGCHgvWmkM
         X/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Uwm/hlzmnNXIPFT+EQgKwvN9+qm6zMRjD06gitahOQI=;
        b=Fk2zq3ah0QQzzpfJjbIPcL6bzH9DVVc0MPol/dcAMQjf79LxaxvYyXSdsp4X6+sR6f
         9QQFK3I3V0hXHQMOaeyQ6hcRS1mp6f5CrxBgv7vzEZI4SiKRslRbUK9yWbqvMl3vBj3h
         BdXu6o2qtZjpsTD0OBPP/UryBK360ZQK2VL8vInxqGpgYSCYZjeECRSE1hFkFLQ2xn9F
         hPH3QPPxJqst+bL1jmB6M0z2UIhu+Ln0bdJGM18DrxRSW1J9ZWZqVokr/nWSF4CniuM+
         hyluNh65CQfQ00l7xOZcrHcedtP5siuphY2tw0anxVcvt15SYZMH/D/GtMK1Bkd6u9R+
         EEAg==
X-Gm-Message-State: AOAM530XvYp2o5V/cNX9oVLjyzpYYqFloYAwWFJVSizz0vNtQE8DWFRk
        jUfFEz8USVM1hXXp0ute6FTGmy9eVTIDlg==
X-Google-Smtp-Source: ABdhPJzeRTk7nWudQe+d99R3a0qB3itFJaduKBXWja7krAdAyYc15N2vyw1KguL16J0Mts+nIXtRiQ==
X-Received: by 2002:a05:6e02:1bee:: with SMTP id y14mr5536778ilv.250.1639539183806;
        Tue, 14 Dec 2021 19:33:03 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j6sm405050ilc.8.2021.12.14.19.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 19:33:03 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
In-Reply-To: <20211112053629.3437-1-colyli@suse.de>
References: <20211112053629.3437-1-colyli@suse.de>
Subject: Re: [PATCH 0/1] bcache patche for Linux v5.16-rc1
Message-Id: <163953918150.250218.18311693877074536456.b4-ty@kernel.dk>
Date:   Tue, 14 Dec 2021 20:33:01 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 12 Nov 2021 13:36:28 +0800, Coly Li wrote:
> Here we have 1 patch from Lin Feng, which is a fix for his previous
> patch which already picked in Linux v5.16 merge window.
> 
> Please take it, and thank you in advance.
> 
> Coly Li
> 
> [...]

Applied, thanks!

[1/1] bcache: fix NULL pointer reference in cached_dev_detach_finish
      commit: aa97f6cdb7e92909e17c8ca63e622fcb81d57a57

Best regards,
-- 
Jens Axboe


