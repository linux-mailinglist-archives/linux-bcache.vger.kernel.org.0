Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629815B5987
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Sep 2022 13:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiILLnz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 12 Sep 2022 07:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiILLny (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Sep 2022 07:43:54 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653EA3C8DD
        for <linux-bcache@vger.kernel.org>; Mon, 12 Sep 2022 04:43:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id v16so19454183ejr.10
        for <linux-bcache@vger.kernel.org>; Mon, 12 Sep 2022 04:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=uQA+aIRjxMq5Er54+7F1flIAXLVuG7LSZ6eBJwAUGBk=;
        b=posP+RvhIVT/MTAiHD9A3ijrOjJjGjGLggO1nXItINadgq9Je8YPtOiffWCeICJW4v
         74JZjMusF36kkk+spDcMwSLigO13zBWg8yl5AqxSIHBp0mv/BKpJ2S3RlJ1iqVM5CxvJ
         K5wxyEdCV7mrB+CY3nkDXSJgymEFDAbq1/PmDu0Ksn+AmsxSU6IgYqbbD672DgSXKRDz
         bRv93ktV//J1yCA7grHa5SLMKGjV8Mlfkx1pbaDSVF0gqmZjmpicO3U9z9yDm1/eEH+1
         Npzi6WCjgy6t2xtV6LxeE0AgCjoFNfVWxCMI5qH2kHa1rBxZfTTnVFXoHELisvdCbldB
         8c+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=uQA+aIRjxMq5Er54+7F1flIAXLVuG7LSZ6eBJwAUGBk=;
        b=4/kwz98hS4JytHBoWmFZLdfMSSi75CjEZIHdU0MqEv+wL2WHDGQ1EKC4w/ticwuv++
         7GhFIHnhWks1FsNIxNDWFuyMM72WvZNq8069kt8qA9H5AYaFZrp7LY6mV2dMsnoIoxyR
         RnDCs0fVUNgrGyJ3JDsQVfpbqWdz480Vtx9pp7thREnyF+LfWlRxDBPLvkf/+muwf+EM
         ADpLK6RktiNfVGAmhmg+p9AgzDt7tc9DvEa9GV4ygQ5QFkUESLchZz7Cj+BiiLRuiTOO
         tebqmtOcYf/kEP8C0NZL5KT1hREF8X+7sDDMLOtqXQZmpw5zngej7/KIvOI+L4EHAm+Q
         rWBQ==
X-Gm-Message-State: ACgBeo01Ja9iRsxwBLWyQdgJbZht8XWgn7RWdVz7RkSjvlXFytaC8IXB
        Bw+qtfqifEWjiqMRKPEZ/6DRPlFFGf0s2z6ZyEw=
X-Google-Smtp-Source: AA6agR7UKX8Ns4M58ZPT0H6MZ2Le1WyAvzel+GnCkfOuMQ508fqs16E3R3tBrhkStq+JWe/tlxhIoRkE4k0565wZEkI=
X-Received: by 2002:a17:906:4fc7:b0:760:5745:1f13 with SMTP id
 i7-20020a1709064fc700b0076057451f13mr18127753ejw.215.1662983030964; Mon, 12
 Sep 2022 04:43:50 -0700 (PDT)
MIME-Version: 1.0
Sender: flanrodolphe@gmail.com
Received: by 2002:a05:6f02:ca18:b0:24:46bd:f03d with HTTP; Mon, 12 Sep 2022
 04:43:49 -0700 (PDT)
From:   Hannah Alex <hannah.aalex1@gmail.com>
Date:   Mon, 12 Sep 2022 11:43:49 +0000
X-Google-Sender-Auth: I0sdtesy0VzgC2QPcEkzC9UOgRA
Message-ID: <CAPF29T+Quo=A-6kUUz+f6VPrh8kXow4KAx10LwM-2Q5q1O7TOQ@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_80,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Dearest,
My name is Hannah Alex, I would like to inquire about your services to be my
foreign partner / investor and help me to transfer and manage my
funds by investing in profit making ventures like buying of company
shares or Real Estate in your country. I have a reasonable sum that I
inherited from my late father, which I would like you to help me invest in
your country.i enclose my personal photos,proof of payment of the fund,my
international passport,my late fathers death certificate and a four page
will from my late father.i am sending you all this so that you can have
confidence that you are dealing with a real person
Note: below are the major reasons I am contacting you.
(1) To provide a new empty bank account in which this money would be
transferred. if you do not want us to use your personal account.
(2) To serve as a guardian of this fund since the bank insisted that their
agreement with my father was that I provide a foreign partner before
releasing the fund.
(3) To make arrangements for me to come over to your country to further my
education and to secure a resident permit in your country.
Please reply as soon as you read this message for more details and proof.
Kind regards.
Hannah Alex.
