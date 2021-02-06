Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B77311CF8
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 12:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBFLtz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 06:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBFLtq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 06:49:46 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898CEC06174A
        for <linux-bcache@vger.kernel.org>; Sat,  6 Feb 2021 03:49:06 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y8so12450940ede.6
        for <linux-bcache@vger.kernel.org>; Sat, 06 Feb 2021 03:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=8sMY8WrKdzHvk5LdByw6IYxeHdnonsBghyQi2+1m63M=;
        b=QNEHG4dONAcuzOuCUjqv0Ko3dehE6+G5jQfIzqL2kR6D/YkAyDNxGZ4kgB8nsYyBPm
         m7yE25QDCqTu8z2UcPYNO6objA5Y/EJvIQtYaYPFtOB2ENMxbdsjoD+uuR3RX5lwsbIW
         jVOJ2+LVxqXYADABVFdqxOcHYdeIQa7Y/cxb59crL7cv4ZwfdzThU3atuQ8MqHskOhsp
         otCU2yM8mWpKjpxIA/L0lSqwqkLJbzvjt2l1bRpY5Isf3n103UDV8J4kthQl+WtHnBkW
         Butl+7tSy0nXjSGrtdo6kRhoE+kSpETZOktiJ5YZXv0YNH6bVnqtQQqPr4sONH3OYgPr
         WHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=8sMY8WrKdzHvk5LdByw6IYxeHdnonsBghyQi2+1m63M=;
        b=V7dpICZQHgeeEktJhagXXxQ1nwelN/4Gv0q034RhlvEL6822ubVWgFepbzyZjSCrUF
         uIYsEZZAwMHliM0Zy8BwHX7BfdR/oHk8yZ3PzadD5GZnCWLhgxAhSHwcuaaMPguTqoTP
         nyb//gej2X0k2OLCfQckOTQGE/rx9P1XoLRbtM5X8589RSrnALQZqfVE+WoErpHaOi14
         xH0NIwaSw9n+BZOVX8v0vXCR4YV3ptH9uk8z47QUBvoyJPrFq3DbytmlXS5adLkJ6R+P
         LTI7jMcb6kxP5oNgbgmID/pNFAzTh48vC+pI28LsHwRzhvh3piIWRPvzcxJufRscQrEs
         YgmQ==
X-Gm-Message-State: AOAM530/8bK9ov3TsW+hm4wZyzH+gTSuDLD6dbj8zDBb4avkbfxOdLbC
        JGmQoy4pEfg7LqsgkYlwVXk8Ln36Gzh4Ew==
X-Google-Smtp-Source: ABdhPJy9UNX2fA0HHQNziuVw6S6Kc6iCxfaNGWDv6QRfdmnJuofdMxwcK1hmHePXlnAziMJIMSUUcA==
X-Received: by 2002:a05:6402:b2d:: with SMTP id bo13mr7983231edb.280.1612612145250;
        Sat, 06 Feb 2021 03:49:05 -0800 (PST)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id b11sm5160046eja.115.2021.02.06.03.49.04
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 03:49:04 -0800 (PST)
To:     linux-bcache@vger.kernel.org
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Subject: bch_cached_dev_attach() The obsoleted large bucket layout is
 unsupported, set the bcache device into read-only
Message-ID: <96e89237-8abe-adf7-8cf0-7065cde81dc3@rolffokkens.nl>
Date:   Sat, 6 Feb 2021 12:49:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

Apparently some bcache users are hit by the message in the subject, see
https://bugzilla.redhat.com/show_bug.cgi?id=1922485

I personally cannot reproduce this, but if the provided info is correct,
a certain kernel upgrade will break existing bcache setups. Is this
really true?

If so, this is a breaking change, which is very harmful.

I hope some of you have suggestions for the people who apparently are
impacted by this.

Best,

Rolf Fokkens

