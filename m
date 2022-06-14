Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91354A774
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Jun 2022 05:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiFNDQx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Jun 2022 23:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiFNDQw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jun 2022 23:16:52 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E8E2D1D7
        for <linux-bcache@vger.kernel.org>; Mon, 13 Jun 2022 20:16:51 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id t1so13064833ybd.2
        for <linux-bcache@vger.kernel.org>; Mon, 13 Jun 2022 20:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=gspLfe3xXQIFEFv3jwJwp7mdcuqpcGfIul+0toyvQBY=;
        b=mnS+thsjCmC5p4rn851URzD5Eyy8OFL5X6t79dX3VL+qqrXJTVtby8FE+H1zegIMat
         sPUGR991d0s14vOjU1W+wvlKzoxzqx/tTGa/cwbtSZDktd+fVwGB3DNeRI0SgtXaHZWD
         46YtCGCWOxNFT7dBjL/2TSW2tZtJD/VwAGiYLEQ2ylzonGlJuMoo3w9PBgWy+A8jb+GZ
         4JZ3vMBDPjZYTivioD65jtWzNIgwTkEGcoaVlsiOamLV+avziVrJJ2b31RWE7c7hUfoW
         /tsnbgQcayEc5jCtmnxElySjGHf4jlg+cWA9butaga2BFPpjg2vMcw7+kctntuZgQz4H
         OUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=gspLfe3xXQIFEFv3jwJwp7mdcuqpcGfIul+0toyvQBY=;
        b=bw8S60/6y260wDkTd9ZRe+WYwpcD9qCHxjroDbjbAsteKd0s9Q5jUv0b0xi4d1szRo
         eF3v5V9w7DAmnlKtinWkiBmBM4ZsS5AyWrwTU6GGx00vhnq1QC6WUtAQGGLgHMmcoyjC
         5cwKqCNM1rQ+YP2hTpFVLDDOpeVfY7izPbvCq+M9kw7RQEWVDvfJNXKUeQqS69Si532i
         mO5Tp5M8JDM/AirAy1m+M6SrIe6FgTvVYkKPqKT3NfEmhf/j/9HgQyahFLZ43NFcpos3
         p1vtcrANMHLt+Eal41wYG1uiQ5rya0np5uAQsHSG1TSyo2a8t5P67FN+UJOXnPI8nHaF
         2SXg==
X-Gm-Message-State: AJIora8WBChzDsFO2N3LgsPjCeOFBwkK7d113uX2OWz1F90VlTaWrpZT
        IVSL1GrhE/NNc4l8meg0w0QK9jYodSZJefBzbyC2G/JqYn/okg==
X-Google-Smtp-Source: AGRyM1sYLm8GuM/z+PJdUgue1LE5o9JU9RFC68IOW1K+Ol6BStY5DRrJQWLoSqUlINFAnLaGk/ClB52uJEdIHlQ+XQc=
X-Received: by 2002:a25:76c1:0:b0:65d:211c:a0da with SMTP id
 r184-20020a2576c1000000b0065d211ca0damr2716962ybc.475.1655176610407; Mon, 13
 Jun 2022 20:16:50 -0700 (PDT)
MIME-Version: 1.0
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Tue, 14 Jun 2022 08:46:39 +0530
Message-ID: <CAC6jXv0CQ8QQn9z5=nAyh80z05j3vxBGBz3HmYFbn2Dj3cfO9A@mail.gmail.com>
Subject: backport 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 to 4.15.0-176.185
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
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

I am trying to backport 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6
(https://www.spinics.net/lists/kernel/msg4386275.html) onto
4.15.0-176.185 , please could someone help me understand which other
patches I need? The cherry-pick needs manual resolution, which I did,
but this is the issue I run into - https://pastebin.com/nBxdpHdJ

I'd be very grateful for some help with this.

Regards,
Nikhil.
